Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZJASU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZJASU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZJASUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:20:25 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:38754 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbZJASUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Gr82itnuvzXa3NHkU2wPgVHT+HsKYxtd1iwxyr73Mc5LTBe8tZJTJryQOXK9DBZsHX
         4/v92Z/9LxYqs7Y5dWmelv1uOHqHB1Q7UX7/F4Of/PRNyNuC4EeHX/mzp3ah75NG0nOi
         a4Xl2pZItrJdS1WA8EMizanbdx+X3RxLo+Yaw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
Date: Thu, 1 Oct 2009 20:21:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-dirty; KDE/4.3.1; i686; ; )
Cc: elendil@planet.nl, manty@manty.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200910011026.17510.elendil@planet.nl> <200910011125.40081.bzolnier@gmail.com> <20091001.094034.161463891.davem@davemloft.net>
In-Reply-To: <20091001.094034.161463891.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200910012021.24260.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 October 2009 18:40:34 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 1 Oct 2009 11:25:40 +0200
> 
> > The problem is that you simply cannot know what is the system state here.
> > 
> > Thus when the unknown block layer request is encountered the best thing
> > you can do is to BUG early instead of allowing the situation when some
> > requests are silently dropped and possibly causing the data corruption.
> 
> Yes, but if you BUG() in this kind of location, the chance of getting
> the debugging information from the user can be close to zero.  We were
> very lucky this time :-)

Do you mean that there is higher chance of user noticing some WARN_ON
warning somewhere in the log than OOPS?  I don't quite believe it..

> If we're tossing a request, signal an error to the submitter.
> 
> I hear we have infrastructure for that :-)

It has its own problems (see blk_execute_rq() overriding error values
for one of many examples)..

Anyway this is completely besides the point here (however please don't
let it stop you from fixing the aforementioned infrastructure) until
the whole issue gets debugged properly and I'd be quite happy to do it
under normal circumstances but since:

- you are always jumping the gun with your strong opinions before people
  even had chance to debug the issue properly and find real root causes
  (vide infamous sparc cmd64x problems, which were caused by the real
   bugfixes and were completely fixed within 48h from the initial report)

- for the last three months you haven't debugged/fixed a single IDE issue
  and you keep dodging every single bug-report 

- I have neither time nor interest for this kind of silly corporate-style
  games (I had some really good laugh few times though :)

- I really do not have to work on IDE (never had, it was always a hobby)

- I'm not the maintainer any longer :)

I simply do not even want to be cc:ed on IDE problems unless it is a paid
job or mail comes from the person who in the past proved the ability to
work well with others.

Thank you for understanding.
