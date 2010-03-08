Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0CHPT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:19:28 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:43168 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755185Ab0CHPTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:19:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [GIT PULL] MFD update for 2.6.34
Date: Mon, 8 Mar 2010 10:20:04 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909022426DC@mi8nycmail19.Mi8.com>
In-Reply-To: <20100308114835.GA16081@linux-sh.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PULL] MFD update for 2.6.34
Thread-Index: Acq+tWa1dmTzJ4SsQMW4iuB47GzPzwAHPYcg
References: <20100307215323.GA21970@sortiz.org> <20100308114835.GA16081@linux-sh.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Samuel Ortiz" <sameo@linux.intel.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Peter Huewe" <peterhuewe@gmx.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Denis Turischev" <denis@compulab.co.il>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       "Mike Turquette" <mturquette@ti.com>,
       "Magnus Damm" <damm@opensource.se>,
       "Yusuke Goda" <goda.yusuke@renesas.com>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Balaji T K" <balajitk@ti.com>, "Moiz Sonasath" <m-sonasath@ti.com>,
       "Eduardo Valentin" <eduardo.valentin@nokia.com>,
       "Haojian Zhuang" <haojian.zhuang@marvell.com>,
       "Joonyoung Shim" <jy0922.shim@samsung.com>,
       "Christoph Egger" <siccegge@stud.informatik.uni-erlangen.de>,
       "Linus Walleij" <linus.walleij@stericsson.com>,
       "Cory Maccarrone" <darkstar6262@gmail.com>,
       "Julia Lawall" <julia@diku.dk>
X-OriginalArrivalTime: 08 Mar 2010 15:19:23.0939 (UTC) FILETIME=[BBF69730:01CABED2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 08, 2010 4:49 AM, Paul Mundt wrote:
> On Sun, Mar 07, 2010 at 10:53:25PM +0100, Samuel Ortiz wrote:
>> H Hartley Sweeten (3):
>>       mfd: Use resource_size() in sm501
>>       mfd: Use resource_size() for t7l66xb
>>       mfd: Use resouce_size for tc6393xb
>> 
> These need to be looked at carefully, at least the sm501 change is
> totally bogus, breaks everything, and stems from a total lack of
> understanding of how the drivers interact.
>
> The I/O resource that's remapped and handled by the MFD takes the full
> size, while the region request is purposely trimmed down so only the
> registers needed by the MFD driver are reserved by the MFD driver. Other
> drivers (like sm501fb) will have their own region requests within the
> same resource at different offsets, all of which are broken after this
> change.
>
> As such, 311e54c07e784fe63d421f724dcc597d1f82ccad at least needs to be
> reverted. I haven't looked at the other two, but if it's a similar
> mechanical change then those should be dropped, too.

Hello Paul,

I took a look at the sm501 patch and see your concern.

The ioremap change to use resource_size looks ok. But the two request_mem_region
changes are an issue due to the point you mentioned above.

The patches to t7166xb and tc6393xb both appear to be ok. They do not have the
same issue.

Regards,
Hartley
