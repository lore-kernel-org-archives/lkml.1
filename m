Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbYEBKPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbYEBKPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYEBKP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:15:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYEBKP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:15:26 -0400
Date: Fri, 2 May 2008 06:15:02 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andres Freund <andres@anarazel.de>, linux-kernel@vger.kernel.org,
       apdim@grecian.net
Subject: Re: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION
 macro is used.
In-Reply-To: <20080501015003.4b7a9058@infradead.org>
Message-ID: <Pine.LNX.4.64.0805020610430.24733@bombadil.infradead.org>
References: <200805012005.42400.andres@anarazel.de> <20080501015003.4b7a9058@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Arjan van de Ven wrote:

> On Thu, 1 May 2008 20:05:41 +0200
> Andres Freund <andres@anarazel.de> wrote:
>
>> Whitout this build fails with unknown macro on
>> e4c576b911e364737b1bf4f5bfdab1c440713f26
>>
>> Hopefully I did everything correct, as this is my first usage of git
>> beside checking out. Also its my first patch on lk....
>>
>> Is an Signed-off-by already appropriate with such an trivial change?
>>
>
> Hi,
>
> maybe the real fix is to remove the use of KERNEL_VERSION in this code??

This is one of the rare cases where the usage of KERNEL_VERSION is valid. 
This is the code there:

#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
#define RADIO_VERSION KERNEL_VERSION(0,7,7)

This macro is required by V4L API to indicate the module version.

One possible solution would be to fork KERNEL_VERSION into something like 
V4L_VERSION, and replace it on drivers/media/video/* and 
drivers/media/radio/*.

Yet, I'm not sure if it would be nice to have two macros with the same 
code.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
