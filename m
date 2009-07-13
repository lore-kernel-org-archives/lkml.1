Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZGMTfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZGMTfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZGMTfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:35:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:50919 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbZGMTfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Kgw5lzloFwEPMBYsJIz79oWvl1O2BDEhRauj//x3mQWvSAzcOA2F3y1b0QQw9ziSq3
         NU8o3SFhGGmKHbDNdtP1OUklbzomYPY0a12yzvNSkzLMmhma9fS82OLP3N7LzoLiCfkU
         jSY0JOkpt4PQPfphKJ1WoM6TwcVibtQWRFcqA=
Message-ID: <4A5B8C60.9000600@gmail.com>
Date: Mon, 13 Jul 2009 21:34:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: yi.zhu@intel.com
CC: reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: iwl: potential deadlock?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we found a potential deadlock in iwl code by our tool.

Can this happen:
iwl_update_tkip_key()
-> spin_lock_irqsave(&priv->sta_lock)
-> iwl_send_add_sta()
   -> iwl_sta_ucode_activate()
      -> spin_lock_irqsave(&priv->sta_lock)
?

Thanks.
