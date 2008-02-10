Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYBJS7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYBJS7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYBJS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:59:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbYBJS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:59:35 -0500
Date: Sun, 10 Feb 2008 10:58:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?S=2E=C3=87a=C4=9Flar_Onur?= <caglar@pardus.org.tr>
cc: Richard Knutsson <ricknu-0@student.ltu.se>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hidave.darkstar@gmail.com, marcel@holtmann.org
Subject: Re: [PATCH] Silent compiler warning introduced by
 acea6852f32b8805e166d885ed7e9f0c7cd10d41 ([BLUETOOTH]: Move children of
 connection device to NULL before connection down.)
In-Reply-To: <200802101621.26432.caglar@pardus.org.tr>
Message-ID: <alpine.LFD.1.00.0802101056530.2896@woody.linux-foundation.org>
References: <200802100457.20143.caglar@pardus.org.tr> <47AEC941.1070504@student.ltu.se> <200802101621.26432.caglar@pardus.org.tr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Feb 2008, S.Çağlar Onur wrote:
> > >
> > > -	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
> > > +	while ((dev = device_find_child(&conn->dev, NULL, __match_tty)) != NULL) {
> > >   
> > Why do you need '!= NULL'?
> 
> I thought its more readable than
> 
> while ((dev = device_find_child(&conn->dev, NULL, __match_tty))) {

Yes indeed. I hate the idiotic "double parenthesis without any meaning". 
I'd much rather see "((..) != NULL)" than "((..))", because the latter is 
totally meaningless semantically (although gcc gives it semantics).

		Linus
