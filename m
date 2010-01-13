Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381Ab0AMMmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0AMMmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773Ab0AMMmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:42:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:13574 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0AMMmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:42:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=YJqnetU8IHjiKxdSTKk/Q5H2IM6ePRjG/lYNsWeciUgBc3KB3/7kfQKy7FiVf0OL/y
         6vFY5pYwFc+Q3JGoqlupzIdRMUsyBkiQ1luiONn9DGEqjNo6wlwjgkhOw8etdsh1GmWB
         yxSES5SqyoTL3/rEP737yNqVHOPrwnlb3/hIg=
Message-ID: <4B4DBF9D.7040002@gmail.com>
Date: Wed, 13 Jan 2010 13:42:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: broken pcmcia_bus_match for dynids
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found that when PCMCIA_DEV_ID_MATCH_FAKE_CIS is set in
match_flags for a dynid, the pcmcia layer may deadlock.

pcmcia_load_firmware in such case calls non-atomic operations
(request_firmware, kzalloc(GFP_KERNEL)), while dynids.lock spinlock is held.

Any ideas how to solve this? Any idea, why p_drv->dynids.lock is not a
mutex instead?

thanks,
-- 
js
