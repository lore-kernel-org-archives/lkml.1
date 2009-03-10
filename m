Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZCJUif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZCJUif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZCJUi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:38:27 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20278 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZCJUi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:38:26 -0400
Date: Tue, 10 Mar 2009 21:38:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>,
       Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 00/31] Add a lot of module alias statements
Message-ID: <20090310213811.56f1ca43@hyperion.delvare>
In-Reply-To: <ac3eb2510903101122h2ff348e8waa3aee20867892fb@mail.gmail.com>
References: <cover.1236702228.git.scott@canonical.com>
	<20090310184624.4e28d18e@hyperion.delvare>
	<1236707391.6339.3.camel@quest>
	<20090310185558.072e6fc6@hyperion.delvare>
	<1236708806.6339.4.camel@quest>
	<ac3eb2510903101122h2ff348e8waa3aee20867892fb@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 19:22:16 +0100, Kay Sievers wrote:
> On Tue, Mar 10, 2009 at 19:13, Scott James Remnant <scott@canonical.com> wrote:
> > On Tue, 2009-03-10 at 18:55 +0100, Jean Delvare wrote:
> >> On Tue, 10 Mar 2009 17:49:51 +0000, Scott James Remnant wrote:
> >> > With current modprobe those files are turned into a binary index that
> >> > can be read and processed *much* faster.
> >>
> >> What would prevent the same binary index from being generated from
> >> user-provided module aliases?
> >
> > Why go to all that effort when adding the alias to the kernel is just a
> > one-line change, and then it shows up along with all of the other
> > aliases that depmod generates the existing binary index from?

Well, _you_ used the performance improvement as one of the arguments to
explain why your patches would be good to have. It's only fair to let
us know if and why there is a relation between where the modalias comes
from (kernel module or user config) and the possibility to improve
performance.

> The problem, with a new kernel or module, we know for forever, that we
> have to run depmod, but this is not the case for depmod config files,
> and not really to manage, to require a binary index update here.

You are not really clear, sorry. As Scott said before, modprobe is run
many many times during boot, so it would seem fair to build a binary
index for all configuration files if it helps with performance. A
simple time comparison between all configuration files and the index
should be much faster than parsing all configuration files each time
modprobe is run, shouldn't it?

> But the main point is that we want to put information where it
> belongs: in the module itself. Just look at the crap we ship in
> /etc/modprobe* and you know that externally maintained configs for
> kernel modules just don't work. :)

This I certainly agree with (for module aliases which do have an
interest, that is), no question about that.

-- 
Jean Delvare
