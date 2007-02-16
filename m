Return-Path: <linux-kernel-owner+w=401wt.eu-S1946032AbXBPSEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946032AbXBPSEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946169AbXBPSEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:04:21 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:55824 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946032AbXBPSEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:04:20 -0500
Message-ID: <45D5F21B.2010804@student.ltu.se>
Date: Fri, 16 Feb 2007 19:04:11 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic boolean-values
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>	 <1171132062.3373.31.camel@mulgrave.il.steeleye.com>	 <20070212122738.b5e9a8af.akpm@linux-foundation.org> <1171644132.3443.27.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1171644132.3443.27.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-02-12 at 12:27 -0800, Andrew Morton wrote:
>   
>> Given that we now have a standard kernel-wide, c99-friendly way of
>> expressing true and false, I'd suggest that this decision can be revisited.
>>
>> Because a "true" is significantly more meaningful (and hence readable)
>> thing than a bare "1".
>>     
>
> OK, I'm really not happy with doing this for three reasons:
>
> 1. It's inviting huge amounts of driver churn changing bitfields to
> booleans
>   
Have been some work done already. Has there been any problems?
> 2. I do find it to be a readability issue.  Like most driver writers,
> I'm used to register layouts, and those are simple bitfields, so I don't
> tend to think true and false, I think 1 and 0.
>   
It is a fundamental difference between an integer and a boolean. Have 
you seen anyone trying to do "bool var = true + true;"? ;)
> 3. Having a different, special, type for single bit bitfields (while
> still using u<n> for multi bit bitfields) is asking for confusion, and
> hence trouble at the driver level.
>   
I don't think a boolean should be view as a single bit bitfield. Ex:
u8 a:1;
...
int b = 4 + a;
is obviously not a boolean, while:
u8 a:1;
...
if (a)
is, and a should be "bool a:1;" (imho)


Richard Knutsson

