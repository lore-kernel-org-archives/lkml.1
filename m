Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZAJRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZAJRqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 12:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZAJRqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 12:46:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1224 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZAJRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 12:46:20 -0500
Date: Sat, 10 Jan 2009 17:46:03 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>
Message-ID: <20090110174602.GA31525@sirena.org.uk>
References: <4968BE74.1070903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4968BE74.1070903@gmail.com>
X-Cookie: Brain off-line, please wait.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Regulator: Use case query (many devices need to reg their
	voltage requirements?)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 03:27:48PM +0000, Jonathan Cameron wrote:

> A number of different embedded system now use main boards (core etc) in
> conjunction with daughter boards.  In these cases different modules may
> be inserted to support different daughter board options from a single kernel
> (and combinations if possible).  Thus we have a situation in which the
> appropriate voltage level can only be established if the various drivers
> specify what they need. The board config may specify numerous devices
> only some of which may actually be present.

The wide range of plug in and subfit options isn't that unusual.
There's quite a few modular reference designs out there, including
designs where the power module is replacable.

When I've considered this in the context of designs I've worked on in
the past I've always thought it would be easiest to represent the plug
in modules in the device tree with the main board regulators being set
up to know only about the supplies they provide to the board.  The plug
in boards could then map how those supplies are distributed within the
boards, using virtual regulators to pass through the supplies from the
main board and being able to supply board-wide requirements for the
design.

I've not actually tried doing this so I've not had a chance to run into
any practical problems with it yet, and I'm not sure how well it maps
onto your system.

> This leads to additional complexity in numerous drivers as they have to act
> as dynamic drivers (terminology from regulator docs) even though they don't
> actually vary the voltage, merely specify what ranges they can work with.

For simple cases it's only one function call, though power requirements
often depend on other system considerations such as clock rates and
analogue design.  There will also be issues if the drivers are for chips
which have multiple software compatible variants with differing power
requirements.

> Is this the best way to handle this situation, or do people have other
> suggestions?

Does the above idea work for you?
