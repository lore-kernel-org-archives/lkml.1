Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbXBMHeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbXBMHeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXBMHeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:34:08 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3610 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXBMHeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:34:07 -0500
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
	to "array_for_each(index, array)"
From: Joe Perches <joe@perches.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ben Nizette <ben.nizette@iinet.net.au>, linux-kernel@vger.kernel.org
In-Reply-To: <45D13C34.2040400@yahoo.com.au>
References: <1171324070.1528.25.camel@localhost>
	 <45D10460.6000903@iinet.net.au> <1171327648.1528.30.camel@localhost>
	 <45D13C34.2040400@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 23:34:12 -0800
Message-Id: <1171352052.1528.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 15:19 +1100, Nick Piggin wrote:
> >>  #define array_for_each(element, array) \
> >>	for (int __idx = 0; __idx < ARRAY_SIZE((array)); \
> >>		__idx++, (element) = &(array[__idx]))
> If you really wanted to introduce your loop, then please call it
> array_for_each_idx, or something to distinguish it.

perhaps:

#define array_for_each(element, array) \
	for ((element) = (array); \
	     (element) < ((array) + ARRAY_SIZE((array))); \
	     (element)++)

#define array_for_each_index(index, array) \
	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)


