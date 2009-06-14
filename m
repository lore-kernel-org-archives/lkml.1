Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZFNOvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZFNOvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 10:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZFNOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 10:51:15 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3237 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZFNOvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 10:51:14 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: "'James Bottomley'" <James.Bottomley@HansenPartnership.com>
cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       linux-scsi <linux-scsi@vger.kernel.org>
Date: Sun, 14 Jun 2009 07:51:07 -0700
Subject: Re: -git tree build failure #2: drivers/net/cnic.c:2520: error:
 implicit declaration of function '__symbol_get'
Thread-Topic: -git tree build failure #2: drivers/net/cnic.c:2520:
 error: implicit declaration of function '__symbol_get'
Thread-Index: Acns+pAjgpEEIrtpTUSqyNajtMClzgACzGkw
Message-ID: <C27F8246C663564A84BB7AB343977242178EE78068@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <1244988911.4096.23.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 662BD1D638G6135635-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:

> On Sat, 2009-06-13 at 19:18 -0700, Michael Chan wrote:
> >
> > This will require some additional infra-structure.  We can look into
> > this when we support the 10G driver.  Thanks.
>
> So if you're going to redo it for the 10G driver, and without the 10G
> driver there really seems no need to have a call by
> reflection in there,
> why not simply do a direct call until the 10G driver is added?  This
> will save everyone potential hassle from what is a highly unusual
> interface.
>

There's an additional usage issue if we switch to a direct call.  The
cnic driver will now have a permanent reference on the bnx2 driver
after it is loaded.  Networking users will be unable to unload the
bnx2 driver once the cnic driver is loaded.

This may not be a serious issue, but one of the goals of the design is
to have minmal impact on networking users.  Since kernel 2.6, users
have been able to unload networking drivers at any time.

Thanks.


