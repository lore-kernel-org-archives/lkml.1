Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXJaQU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXJaQU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXJaQUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:20:18 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40199 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbXJaQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:20:17 -0400
Date: Wed, 31 Oct 2007 12:20:16 -0400
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Paul Jimenez <pj@place.org>, rgooch@atnf.csiro.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtrr use type bool
Message-ID: <20071031162016.GD27646@csclub.uwaterloo.ca>
References: <20071031035718.A1D9E8B2A@place.org> <47289EE3.8080706@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47289EE3.8080706@student.ltu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 04:27:31PM +0100, Richard Knutsson wrote:
> Paul Jimenez wrote:
....
> >-			usage_table[i] = usage_table[replace] + !!increment;
> >+			usage_table[i] = usage_table[replace] + increment;
> >  
> This seems a bit strange, using a boolean as an integer (yes I know, it 
> works but semantically...). What about:
> 
> +			usage_table[i] = usage_table[replace];
> +			usage_table[i] += increment ? 1 : 0;

What is wrong with:
usage_table[i] = usage_table[replace];
if (increment)
	usage_table[i]++;

I hate code with the '?' operator in general.  It's a conditional either
way, and at least this way you wouldn't even have to do a store in one
of the two cases 9although if the compiler can't figure out that is the
case already, then it really sucks).

Pauls code at least didn't involve a conditional at all, but on the
other hand is less clear to read.

--
Len Sorensen
