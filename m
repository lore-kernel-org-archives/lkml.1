Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZDUOat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZDUOat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZDUOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:30:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37198 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZDUOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:30:39 -0400
Date: Tue, 21 Apr 2009 15:30:30 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: James Kosin <jkosin@beta.intcomgrp.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090421143030.GG25828@sirena.org.uk>
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EDC935.7080308@beta.intcomgrp.com>
X-Cookie: Rubber bands have snappy endings!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:25:09AM -0400, James Kosin wrote:

> Then the GPS drivers should be made aware and let the drivers handle the
> on/off interface.  If a user is allowed to turn interfaces on/off at
> will with this then drivers could suffer from (shock)...  ie: you could
> turn off your hard-drive in a middle of a write by the driver corrupting
> data, if handled in the driver it could finish the write before turning
> off the drive.  I know this is a far stretch from a GPS were the device
> is only READ only.

The proposed driver is a platform device.  This means that in order for
user space to have anything to access the kernel will have to explicitly
register a platform device and provide it with configuration.  Further,
since the driver is a standard regulator consumer the kernel will also
have to have provided explicit constraints which grant permission to the
driver to modify the state of the regulator.

> I do agree it could be useful, but we need to be careful on how much
> control the user has over the drivers and system.  To an extreme, a user
> could be able to turn off CPU cores outside of the drivers control
> causing serious pipeline hazards that would need to be handled at the
> driver level.  This would not be an issue for GPS were the data is read

This is why the regulator core requires that explicit configuration be
done by the machine in order to allow any changes to the regulator
state.
