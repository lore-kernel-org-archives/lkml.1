Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYKCPCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYKCPCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYKCPCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:02:36 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38730 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbYKCPCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:02:36 -0500
X-Sasl-enc: ZoH8QnvfwM1L5C+E1FqH0wpo7jHTCia0hXzKnrnJW+Rk 1225724553
Date: Mon, 3 Nov 2008 13:02:29 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081103150229.GF31078@khazad-dum.debian.net>
References: <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net> <20081103141836.GA31894@srcf.ucam.org> <490F0ACC.4000808@tuffmail.co.uk> <20081103145145.GD31078@khazad-dum.debian.net> <20081103145543.GA496@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103145543.GA496@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008, Matthew Garrett wrote:
> On Mon, Nov 03, 2008 at 12:51:45PM -0200, Henrique de Moraes Holschuh wrote:
> > Not if you can enter or exit HARD_BLOCK, you're not.  If you cannot it is
> > fine.  But if you can, you really need to rfkill_force_state() on resume,
> 
> The state can always be overridden by software, so I think we're fine 
> there.

The only things that can go out of HARD_BLOCK are rfkill_force_state() or a
call to get_state(), which will only happen much later (not during the
resume process).

> > And the rfkill core seems to be buggy when you call force_state() on resume,
> > which you guys didn't hit because you're not doing it yet.  See my other
> > email...
> 
> Just to make sure: in the case where we *don't* support hard blocking, 
> there's no need to do anything special in the driver on resume and 
> rfkill should (but currently doesn't) do the right thing itself?

Right now, you should still rfkill_force_state().  Please wait for an hour
or two while I clean up that broken resume handling, and I will tell you for
sure.

Chances are I can "un-optimize" rfkill_toggle_radio to always use
get_state(), and then your answer will be "yes, you don't need to
rfkill_force_state() ever if you don't support HARD_BLOCK".

Note that only using get_state() is NOT good for the user interface if the
firmware or hardware can change the rfkill state of the device.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
