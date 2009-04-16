Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZDPJYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZDPJYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbZDPJYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:24:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZDPJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:24:44 -0400
Date: Thu, 16 Apr 2009 11:24:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Mark Lord <lkml@rtr.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
In-Reply-To: <49E5EAD7.7000309@rtr.ca>
Message-ID: <alpine.LNX.2.00.0904161123180.13028@wotan.suse.de>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca> <200904140945.14652.dmitry.torokhov@gmail.com> <49E4C9CF.5060504@rtr.ca> <alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
 <49E5EAD7.7000309@rtr.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Mark Lord wrote:

> > Yes, hid-belking is a good example of trivial driver that sits on a HID bus
> > for you, as it utilizes the ->input_mapping() callback, which is probably
> > the only callback from HID core you'd need.
> Actually, the input-mapping() alone won't do the job here.
> This Twinhan remote control sends single-byte codes for most buttons, 
> but some buttons send multi-byte codes, and we have to discard the 
> extraneous bytes somehow.

If the usages make it through the generic HID layer (depends on the report 
descriptor of the device), then just registering hid_driver with ->event() 
set to your callback and fixing this on the fly could be enough.

-- 
Jiri Kosina
SUSE Labs
