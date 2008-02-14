Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbYBNS3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbYBNS3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760817AbYBNS3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:29:18 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:42962 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbYBNS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:29:17 -0500
Date: Thu, 14 Feb 2008 19:29:16 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
In-Reply-To: <20080214100617.GB10713@shadowen.org>
Message-ID: <Pine.LNX.4.64.0802141928130.694@fbirervta.pbzchgretzou.qr>
References: <20080210143240.GA13317@joi> <Pine.LNX.4.64.0802132043410.29154@fbirervta.pbzchgretzou.qr>
 <20080214100617.GB10713@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 14 2008 10:06, Andy Whitcroft wrote:
>On Wed, Feb 13, 2008 at 08:43:58PM +0100, Jan Engelhardt wrote:
>> 
>> On Feb 10 2008 15:33, Marcin Slusarz wrote:
>> >Checkpatch in current mainline outputs following errors:
>> >
>> >$ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
>> >ERROR: need consistent spacing around '*' (ctx:WxV)
>> >#205: FILE: fs/udf/misc.c:205:
>> >+       tag *tag_p;
>> >            ^
>> 
>> I'd say "don't add any new typedefs" (and perhaps get rid of old ones).
>
>It should be doing that at the site of the new typedef :)
>
Additionally, yes.
Given:

typedef struct {
	...
} tag_t;
void foo(void)
{
	tag_t name;
}

A user adding

+	tag_t newthing;

could at the same time give the struct a name if it already does not
have one and instead use

+	struct tag newthing;

then.
