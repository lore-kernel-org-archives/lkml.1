Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYEAWHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYEAWHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765102AbYEAWGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:06:10 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39281 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764231AbYEAWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:06:04 -0400
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, megaraidlinux@lsi.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <481A3781.8080100@gmail.com>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
	 <20080501142305.77433e50.akpm@linux-foundation.org>
	 <481A3781.8080100@gmail.com>
Content-Type: text/plain
Date: Thu, 01 May 2008 17:05:59 -0500
Message-Id: <1209679559.14864.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 23:34 +0200, Jiri Slaby wrote:
> On 05/01/2008 11:23 PM, Andrew Morton wrote:
> > On Thu,  1 May 2008 17:56:02 +0200
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> >> megaraid_sas suspend and resume are inappropriatelly placed in
> >> __devinit section.
> > 
> > That's a box-killer, isn't it?
> 
> I think so -- the non-CONFIG_HOTPLUG ones.

CONFIG_HOTPLUG is only settable to 'n' if you're CONFIG_EMBEDDED which
has a zero set intersection with the users of megaraid, so in practical
terms, there's no actual box it could kill.

this whole 

#if CONFIG_PM
define suspend resume
#else
set suspend resume methods to null
#endif

Is completely analagous to what we used to do with CONFIG_HOTPLUG before
we had the __dev.* sectional annotations.  Since the expanding
bureacracy is determined to keep the _dev.* sections in spite of the
pain, could we not at least make the machinery do something vaguely
useful and expand it to confine the pm routines to sections which can be
discarded if CONFIG_PM is n?

James


