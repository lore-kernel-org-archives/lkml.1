Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZIMP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZIMP7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZIMP7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:59:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:44896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZIMP7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:59:15 -0400
Date: Sun, 13 Sep 2009 17:59:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: special HID & Kconfig: odd behavior in gconfig
In-Reply-To: <1252681027.2282.23.camel@castor>
Message-ID: <alpine.LNX.2.00.0909131758280.17028@wotan.suse.de>
References: <1252681027.2282.23.camel@castor>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Richard Kennedy wrote:

> I use gconfig & and cannot turn off any of the special HID devices.
> 
> the Kconfig for them all have the same pattern e.g.
> 
> config HID_DRAGONRISE
> 	tristate "DragonRise Inc. support" if EMBEDDED
> 	depends on USB_HID
> 	default !EMBEDDED
> 
> The 'if EMBEDDED' on the tristate line seems to confuse gconfig and it
> sets them all to m & does not let me set them to N. I'm building this on
> a standard desktop machine.
> 
> Any idea what the intention of this was? or can we just remove the if
> embedded part?

Hi Richard,

actually this question has been raised by several people in the past
already. Copy/pasting the latest reply I have sent on this topic

===

mostly this is because we don't want to bother users with asking for every 
single quirky device/vendor, as there are unfortunately a lot of them. 
Usually compiling everything in doesn't waste runtime footprint (the 
modules don't get loaded unless needed), and they don't cost too much disk 
space either. And if you really want to disable them, CONFIG_EMBEDDED 
allows you to do that.

Please see last paragraph on

        http://lkml.org/lkml/2008/10/14/284

===

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
