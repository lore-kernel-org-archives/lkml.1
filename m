Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYKNTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYKNTVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYKNTUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:20:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:30804 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYKNTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FtuqTMBu5rEph8K+8WQZQhuIo6wf89dt4CZqxAwY+urLcr3VH+Pqpso5Pl7g3eUKcc
         2+5TtONrq6xdbvWVdaSggnft89oFfwubRkYlbUn9L7bEVzfWlTeEwBs6JoK/9rNlt9cG
         YE+TJFvDXZrgilWMxu9UegVk+7L98xMl4Tk5k=
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
 are __le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
References: <1226686796.5483.33.camel@brick> <491DCBDD.4000703@linuxtv.org>
	 <1226689669.5483.36.camel@brick>
	 <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 11:20:38 -0800
Message-Id: <1226690438.5483.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 14:15 -0500, Michael Krufky wrote:
> On Fri, Nov 14, 2008 at 2:07 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > On Fri, 2008-11-14 at 14:05 -0500, Michael Krufky wrote:
> >> Wouldn't it be nicer to just switch on
> >> cpu_to_le16(udev->descriptor.idVendor) ?  This would be a 1-line change,
> >> compile to a smaller footprint, and be easier to read.
> >>
> >> Personally, I prefer to try to avoid duplicating code in places where a
> >> single operation may occur centrally.
> >
> > On a little-endian arch it makes no difference obviously, but on a
> > big-endian arch it's the difference between compile-time and runtime
> > byteswapping.
> >
> 
> Its not my driver, but I think that doing the operation on the switch
> is prettier than doing it on each case statement.  Also, it would
> avoid future bugs, if somebody decides to add new cases to the switch
> block.

The alternative is to define the vendor ids as little-endian in the headers
then you don't need the endian swap in the switch or the case, but that would
require looking at the other uses first....or gently encourage more people to run sparse ;-)

Harvey

