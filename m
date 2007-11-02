Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbXKBKTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbXKBKTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXKBKT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:19:27 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:42235 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbXKBKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:19:26 -0400
In-Reply-To: <1193985008.1782.7.camel@concordia>
References: <200710261437.29117.ossthema@de.ibm.com>	 <1193610737.9637.1.camel@concordia>
	 <OF79E7ACE7.5D0488CE-ONC1257384.002E58C0-C1257384.002F8561@de.ibm.com>	 <1193784636.32504.4.camel@concordia>
	 <OF59B5FFD2.0294206F-ONC1257385.006A802D-C1257385.006CB6BB@de.ibm.com> <1193985008.1782.7.camel@concordia>
Subject: Re: [PATCH] ehea: add kexec support
To: michael@ellerman.id.au
Cc: Jan-Bernd Themann <THEMANN@de.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <MEDER@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, ossthema@linux.vnet.ibm.com,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <TKLEIN@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF3FAFDB41.AF236738-ONC1257387.00376233-C1257387.00389861@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Fri, 2 Nov 2007 11:19:12 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 02/11/2007 11:19:20
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Michael Ellerman <michael@ellerman.id.au> wrote on 02.11.2007 07:30:08:

> On Wed, 2007-10-31 at 20:48 +0100, Christoph Raisch wrote:
> > Michael Ellerman <michael@ellerman.id.au> wrote on 30.10.2007 23:50:36:
> If that's really the way it works then eHEA is more or less broken for
> kdump I'm afraid.

We think we have a way to workaround this, but let me first try to
explain the base problem.

DD allocates HEA resources and gets firmware_handles for these resources.
To free the resources DD needs to use exactly these handles.
There's no generic firmware call "clean out all resources".
Allocating the same resources twice does not work.

So a new kernel can't free the resources allocated by an old kernel,
because the numeric values of the handles aren't known anymore.

Potential Solution:
Hea driver cleanup function hooks into ppc_md.machine_crash_shutdown
and frees all firmware resources at shutdown time of the crashed kernel.
crash_kexec continues and loads new kernel.
The new kernel restarts the HEA driver within kdump kernel, which will work
because resources have been freed before.

Michael, would this work?

Gruss / Regards
Christoph R.

