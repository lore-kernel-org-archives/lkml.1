Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbYHDVV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbYHDVV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYHDVVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:21:19 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57607 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbYHDVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:21:18 -0400
X-Sasl-enc: XLKy+6E0wgiJF058MUYnxTmnN4QfCoVD3L26zk6gvy2Q 1217884877
Date: Mon, 4 Aug 2008 18:21:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] eeepc-laptop: Use standard interfaces
Message-ID: <20080804212113.GB24927@khazad-dum.debian.net>
References: <20080804170833.GA9513@srcf.ucam.org> <20080804171504.GB9513@srcf.ucam.org> <200808041953.38829.IvDoorn@gmail.com> <20080804173627.GA10302@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804173627.GA10302@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2008, Matthew Garrett wrote:
> On Mon, Aug 04, 2008 at 07:53:38PM +0200, Ivo van Doorn wrote:
> > On Monday 04 August 2008, Matthew Garrett wrote:
> > > eeepc-laptop currently only sends key events via ACPI and has 
> > > non-standard rfkill control. Add an input device and use the rfkill 
> > > infrastructure.
> > > 
> > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > 
> > Please use the rfkill_force_state() to report state changes,
> > that will ensure that the events are immediately send to the
> > rfkill layer.
> 
> Why does writing to the sysfs file not generate an update implicitly? 

It does.  rfkill_force_state() is used to propagate state changes done by
outside sources back into rfkill.  All internal changes caused by rfkill or
known to rfkill are dealt with by rfkill itself.

If there are no such outside sources, you don't need rfkill_force_state() or
get_state() at all, as long as you set rfkill->state properly before you
call rfkill_register.

BTW: if it has a hardware rfkill switch that overrides the rfkill
controller, that DOES count as an outside source of changes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
