Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZFYNOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZFYNOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZFYNOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:14:35 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56049 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZFYNOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:14:34 -0400
Message-ID: <c17c39d3458ffa3aebee03ff26d90c23.squirrel@www.hardeman.nu>
In-Reply-To: <20090625134946.46109bac@lxorguk.ukuu.org.uk>
References: <20090624213645.GA18843@hardeman.nu>
    <20090624234501.3d35642f@lxorguk.ukuu.org.uk>
    <55ca74318001aae803805a7bccfaca36.squirrel@www.hardeman.nu>
    <20090625134946.46109bac@lxorguk.ukuu.org.uk>
Date: Thu, 25 Jun 2009 15:14:36 +0200 (CEST)
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP 
          id WEC1022)
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, jesse.barnes@intel.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, June 25, 2009 14:49, Alan Cox wrote:
> You can certainly stop the serial layer grabbing it (or undo that)
> providing the port isn't the console (which in this case would make no
> sense).

Which way of stopping the serial layer from grabbing the port did you have
in mind?

If I call uart_remove_one_port, I'd need to get struct uart_driver *drv
and struct uart_port *port from somewhere. Also, it'd be quite ugly to
have /dev/ttyX appear and magically disappear during boot (since 8250 is
compiled in with most distro kernels and my driver would be a module which
would be loaded much later).

The only alternative I could think of would be to get the serial core to
check with acpi_check_resource_conflict for ports that have not been
discovered via PNP/ACPI?

-- 
David Härdeman

