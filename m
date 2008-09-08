Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYIHS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYIHS0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYIHS01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:26:27 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:30790 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752406AbYIHS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:26:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0pg4BGntBi91B6DJZONd9TD9kPiM0DcND7WEpr0DHhNqRbu2hQ+yVkbJfX9Hi4vPStI7eRJBW9vQWj023luGb/E538ym1fNUKviBKoGVdXvblDoR9dvWe+aw2AmYjxgTy+bGEnIKecnG3fhnImKBj3me/zOWEWRoYN5Ct4yn+oE=  ;
X-YMail-OSG: LbtDE3IVM1nCe8Ajhde1Uk1QaO4fmww9rb.gjMLXtp66.Z6sjxZvtf45qayPXvIcWSp8j1DIGIgVB58NIuQjtNmGPcOHQo4n77XiVD536DlIsVMHfNr6s66avmlSt6VCMUs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 11:19:44 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Parisc List <linux-parisc@vger.kernel.org>
References: <1220889205.8074.16.camel@localhost.localdomain>
In-Reply-To: <1220889205.8074.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081119.45074.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, James Bottomley wrote:
> Put it back again by making RTC_CLASS 
> unselectable if the architecture is parisc.

Easier if those distros just wouldn't select RTC_CLASS then.  :)

And long term, better to work with RTC_CLASS.  Eliminate that
crufty asm-parisc/rtc.h file and one more GEN_RTC user; and
share more widely-used infrastructure.

If I read things right, that would be easy:  the PARISC RTC is
two firmware calls, ptc_tod_{read,set}(), which would map to
RTC class {read,set}_time() methods of about six lines each.
The RTC framework can do UIE emulation, if needed.

- Dave

