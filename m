Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbXKOXHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbXKOXHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbXKOXH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:07:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56571 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765819AbXKOXH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:07:27 -0500
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
From: Jim Keniston <jkenisto@us.ibm.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <863e9df20711150700i3c84374ava108f5b585e8498b@mail.gmail.com>
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
	 <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
	 <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150700i3c84374ava108f5b585e8498b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 16:07:24 -0800
Message-Id: <1195171644.3804.124.camel@dyn9047018096.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-15 at 20:30 +0530, Abhishek Sagar wrote:
> On Nov 15, 2007 4:21 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> > 2. Simplify the task of correlating data (e.g., timestamps) between
> > function entry and function return.
> 
> Would adding of data and len fields in ri help? Instead of "pouching"
> data in one go at registration time, this would let user handlers do
> the allocation

Yes and no.  Adding just a data field -- void*, or maybe unsigned long
long so it's big enought to accommodate big timestamps -- would be a big
improvement on your current proposal.  That would save the user the
drudgery of mapping the ri pointer to his/her per-instance data.
There's plenty of precedent for passing "private_data" values to
callbacks.

I don't think a len field would help much.  If such info were needed, it
could be stored in the data structure pointed to by the data field.

I still don't think "letting [i.e., requiring that] user handlers do the
allocation" is a win.  I'm still interested to see how this plays out in
real examples.

> and allow them to use different kinds of data
> structures per-instance.

I haven't been able to think of any scenarios where this would be
useful.  A "data pouch" could always contain a union, FWIW.

> 
> - Abhishek Sagar 

Jim


