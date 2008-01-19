Return-Path: <linux-kernel-owner+w=401wt.eu-S1764607AbYASCQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764607AbYASCQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 21:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYASCQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 21:16:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317AbYASCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 21:16:15 -0500
Date: Sat, 19 Jan 2008 02:16:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: something odd in emu10k1/emufx
Message-ID: <20080119021614.GD27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In copy_tlv() we have
        tlv = kmalloc(data[1] * 4 + sizeof(data), GFP_KERNEL);
        if (!tlv)
                return NULL;
        memcpy(tlv, data, sizeof(data));
        if (copy_from_user(tlv + 2, _tlv + 2, data[1])) {
                kfree(tlv);
                return NULL;
        }
which looks rather odd, since either we kmalloc too much or copy too little...
Comments?
