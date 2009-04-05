Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbZDEQoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbZDEQoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 12:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZDEQoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 12:44:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58763 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZDEQoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 12:44:22 -0400
Date: Sun, 5 Apr 2009 09:44:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dipankar@in.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, peterz@infradead.org, lethal@linux-sh.org,
       kernel@wantstofly.org, andi@firstfloor.org, kyle@mcmartin.ca,
       deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] Convert CONFIG_SMP=y powerpc defconfigs to
	TREE_RCU.
Message-ID: <20090405164420.GI6893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <3181463559098978317@unknownmsgid> <625fc13d0904040621g7b89cd2cq9681ce80635a65c4@mail.gmail.com> <20090404163149.GC6893@linux.vnet.ibm.com> <20090405101756.GA10490@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20090405101756.GA10490@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 05, 2009 at 12:17:56PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Sat, Apr 04, 2009 at 09:21:58AM -0400, Josh Boyer wrote:
> > > On Fri, Apr 3, 2009 at 8:27 PM, Paul E. McKenney
> > > <paulmck@linux.vnet.ibm.com> wrote:
> > > > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Why would one want to do this?  The commit log doesn't explain the
> > > switch and why it's great.  Mostly because the commit log doesn't
> > > exist.  (I'll stop channeling Andrew now)
> > 
> > Indeed, I am sure that I will get the hang the relevant git 
> > commands at some point, but clearly am not yet there.
> > 
> > The thing that is great about this patch is that it is a step on 
> > the way to retiring Classic RCU entirely.
> 
> I'd suggest you dont do these dozens of defconfig updates at all - 
> arch maintainers can do this themselves, once the core kernel 
> default has been flipped.

I am of course personally quite happy with this approach in the short
term, as I would only need to worry about one patch.

My one concern would be that we cannot retire Classic RCU until all the
arch maintainers remove CONFIG_CLASSIC_RCU=y from their defconfig files.
However, given that the attached script suffices, I am not too worried
about that.

Of course, none of this matters unless people agree that Tree RCU has
proven reliable enough to be made default.  So, any objections to such
a change at this point?

							Thanx, Paul

--MGYHOYXEY6WxJCY8
Content-Type: application/x-sh
Content-Description: 2rcutree.sh
Content-Disposition: attachment; filename="2rcutree.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A#=0A# Switches the roles of CONFIG_CLASSIC_RCU and CONFIG_TREE_=
RCU in the=0A# specified defconfig files.  The old version of the file is r=
etained=0A# with a .orig extension.  The .orig is created even if no change=
s were=0A# made, but git figures out the difference just fine.=0A#=0A# Peop=
le wishing fully automatic operation can do the following:=0A#=0A#	sh 2rcut=
ree.sh `grep -l CONFIG_SMP=3Dy *defconfig`=0A#=0A# This program is free sof=
tware; you can redistribute it and/or modify=0A# it under the terms of the =
GNU General Public License as published by=0A# the Free Software Foundation=
; either version 2 of the License, or=0A# (at your option) any later versio=
n.=0A#=0A# This program is distributed in the hope that it will be useful,=
=0A# but WITHOUT ANY WARRANTY; without even the implied warranty of=0A# MER=
CHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A# GNU General =
Public License for more details.=0A#=0A# You should have received a copy of=
 the GNU General Public License=0A# along with this program; if not, write =
to the Free Software=0A# Foundation, Inc., 59 Temple Place - Suite 330, Bos=
ton, MA 02111-1307, USA.=0A#=0A# Copyright (C) IBM Corporation, 2009=0A#=0A=
# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>=0A=0Afor i in "$@"=
=0Ado=0A	mv $i $i.orig=0A	sed -e 's/CONFIG_CLASSIC_RCU\([=3D ]\)/CONFIG_@@@=
\1/' \=0A	    -e 's/TREE_RCU\([=3D ]\)/CLASSIC_RCU\1/' \=0A	    -e 's/CONFI=
G_@@@\([=3D ]\)/CONFIG_TREE_RCU\1/' \=0A	    < $i.orig > $i=0Adone=0A
--MGYHOYXEY6WxJCY8--
