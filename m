Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZFRNzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZFRNzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbZFRNyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:54:55 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45345 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbZFRNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:54:55 -0400
Date: Thu, 18 Jun 2009 15:54:57 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <pfe@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>, Andreas Mohr <andi@lisas.de>,
       Ed Tomlinson <edt@aei.ca>, akpm@linux-foundation.org,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Message-ID: <20090618135457.GA927@rhlx01.hs-esslingen.de>
References: <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net> <20090617122022.GA13141@rhlx01.hs-esslingen.de> <cone.1245309039.632882.31537.1000@arca> <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com> <cone.1245322548.289821.31537.1000@arca> <9ea470500906180442r7beb49a8odcb3bf602df78b47@mail.gmail.com> <cone.1245325770.489357.31537.1000@arca> <9ea470500906180545j5e1a78f7qcb887ad843b489f3@mail.gmail.com> <cone.1245331895.30957.31537.1000@arca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1245331895.30957.31537.1000@arca>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 03:31:35PM +0200, Peter Feuerer wrote:
> You are partly right, setting the fan to auto in  
> "acerhdf_revert_to_bios_mode" can be removed, as this is done by the 
> thermal layer when calling "acerhdf_set_cur_state" with 
> disable_kernelmode=1.

No, it was done _specifically_ this way to make sure that _exactly when_
switching away from kernel mode FAN_AUTO _always_ (by asking people to
always call this central function) gets set, too.
I don't want to depend on a separate, _uncontrollable_ entity
(thermal layer function) to have to run sometime later
in order to set the fan to FAN_AUTO (IOW, BIOS-controlled mode) accordingly.
_Of course_ this FAN_AUTO call is redundant in _most_ cases, but very
intentionally so. Anything else would be woefully unsafe (with a fan
remaining in FAN_OFF position until machine meltdown).

Andreas Mohr
