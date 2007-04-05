Return-Path: <linux-kernel-owner+w=401wt.eu-S1161108AbXDEDY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161108AbXDEDY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161110AbXDEDY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:24:57 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:12882 "EHLO
	asav16.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161108AbXDEDY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:24:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMAPkHFEZKhRO4UGdsb2JhbACHNohCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: usb hid: reset NumLock
Date: Wed, 4 Apr 2007 23:24:55 -0400
User-Agent: KMail/1.9.3
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
References: <20070330105924.01a16dd6.zaitcev@redhat.com> <20070402161225.2866c002.zaitcev@redhat.com> <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704042324.56345.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007 04:52, Jiri Kosina wrote:
> On Mon, 2 Apr 2007, Pete Zaitcev wrote:
> 
> > How about this?
> 
> Looks quite fine to me.
> 
> But in case that Dmitry's patch "Input: add generic suspend and resume for 
> uinput devices" fixes your issue too, I wouldn't merge it as it won't be 
> needed. Could you please let me know?

Unfortunately my patch is crap. We should not be sending events down
dev->event() until dev->open() has been called because many drivers
start hardware from there and not ready until then.

So it is HID driver responsibility to properly reset leds after all.

-- 
Dmitry
