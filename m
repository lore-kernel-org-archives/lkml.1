Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbXFFFQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbXFFFQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbXFFFP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:15:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32851 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbXFFFP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:15:58 -0400
Date: Tue, 5 Jun 2007 22:15:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: young dave <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused kmalloc
 bug
In-Reply-To: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706052211500.7930@schroedinger.engr.sgi.com>
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Note that the corruption seems to have its cause in a decrement done at
offset 16 into the object pointing to the refcount in struct hci_dev. So 
it looks like the refcount was decremented after the object was freed.

sysfs related?
