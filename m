Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYCKUrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYCKUrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYCKUrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:47:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:47280 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYCKUrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:47:17 -0400
In-Reply-To: <1205254569.22317.8.camel@brick>
References: <1205254569.22317.8.camel@brick>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <8d55c7ae2d3c851013db4857506b537c@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] bitops: add 8-bit and 16-bit rotation functions
Date: Tue, 11 Mar 2008 21:45:36 +0100
To: Harvey Harrison <harvey.harrison@gmail.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * rol16 - rotate a 16-bit value left
> + * @word: value to rotate
> + * @shift: bits to roll
> + */
> +static inline __u16 rol16(__u16 word, unsigned int shift)
> +{
> +	return (word << shift) | (word >> (16 - shift));
> +}

This doesn't work for shift values of 0: you get word >> 16, and
shifts greater than or equal to the word size aren't valid C.  GCC
will warn about this, too.


Segher

