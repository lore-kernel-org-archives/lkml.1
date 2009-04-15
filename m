Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZDOOKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZDOOKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZDOOKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:10:35 -0400
Received: from rtr.ca ([76.10.145.34]:55178 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbZDOOKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:10:34 -0400
Message-ID: <49E5EAD7.7000309@rtr.ca>
Date: Wed, 15 Apr 2009 10:10:31 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca> <200904140945.14652.dmitry.torokhov@gmail.com> <49E4C9CF.5060504@rtr.ca> <alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 14 Apr 2009, Mark Lord wrote:
> 
>>> I think if you take drivers/hid/hid-belkin.c as a template the 
>>> conversion will take you no time.
>> Okay, I can have a look at that one.  Thanks.
> 
> Yes, hid-belking is a good example of trivial driver that sits on a HID 
> bus for you, as it utilizes the ->input_mapping() callback, which is 
> probably the only callback from HID core you'd need.
..

Actually, the input-mapping() alone won't do the job here.

This Twinhan remote control sends single-byte codes for most buttons,
but some buttons send multi-byte codes, and we have to discard the
extraneous bytes somehow.

Cheers
