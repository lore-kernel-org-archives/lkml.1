Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbXLOAMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbXLOAMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbXLOAMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:12:24 -0500
Received: from [194.117.236.238] ([194.117.236.238]:59311 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXLOAMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:12:23 -0500
Date: Sat, 15 Dec 2007 02:10:32 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071215021032.252455be@linux360.ro>
In-Reply-To: <47630521.4060505@redhat.com>
References: <20071214004442.5f9eba88@linux360.ro>
	<p737ijigr8c.fsf@bingen.suse.de>
	<20071214143941.2c7dcfb4@linux360.ro>
	<20071214101720.GA10981@one.firstfloor.org>
	<47630521.4060505@redhat.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 17:35:13 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> On 12/14/2007 05:17 AM, Andi Kleen wrote:
> >> so do whatever is necessary to enable dynticks. 
> > 
> > dynticks' main purpose is to save power, but C1e saves more power.
> > Disabling C1e for dynticks would be a fairly useless default
> > trade off.
> > 
> 
> What about machines where the BIOS has disabled C1e on CPU 0 but
> left it enabled on CPU 1 ??

Do you mean Linux should enable C1E on CPU 0 if it's detected on CPU 1?
C3 + dynticks make up a better power saver than simply C1E, as far as I
know. Higher C-states should be enabled on such CPUs, as AMD docs say
firmware should either enable C1E or C2 & C3 (it must provide one of
these mutually exclusive options). I take having C1E on the second CPU
but not the first as an attempt on BIOS's part to provide higher
C-states instead of the former. How broken is it, really?

But maybe someone with access to such hardware can tell us what
happens: does he get C2/C3 power states under such circumstances?
