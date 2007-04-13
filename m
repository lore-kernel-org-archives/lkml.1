Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXDMGfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXDMGfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXDMGfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:35:06 -0400
Received: from smtp109.plus.mail.re2.yahoo.com ([206.190.53.34]:23101 "HELO
	smtp109.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752063AbXDMGfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:35:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
  b=2T+iOJPceEsFOHGaFz95FsEaV1dK3rR8pUfwSGEIApCVU+68QXywOuBHJiWLHOyeyNkTg8ZgKVozBIa2SrzGS1p17+Uc6GQkwHIE/n7yTKDG0M5L+dY8544KtNOGJU+KLTcRDy6RJ8KkairAmOuupQZXJE7KLWLOZ2oJJXboX4U=  ;
X-YMail-OSG: Df2zxMMVM1kcNfA5SnyhKLSxbMHZisSqOeKGC26RdUtxZcw9r17YU25k0Wj8TrOFzZzcONvCCT03c_eY.NALSr1plFx2C7X.ffQJxWhcCc4z.MmaoT0YHUbpH20fxVndN6XI8W4TYzzj0Jw-
Date: Fri, 13 Apr 2007 08:35:00 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] fix tex error when building pdfdocs
Message-ID: <20070413063459.GA4075@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070412203842.GA14245@zmei.tnic> <20070412164851.0c5d6e54.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412164851.0c5d6e54.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 04:48:51PM -0700, Randy Dunlap wrote:
> On Thu, 12 Apr 2007 22:38:42 +0200 Borislav Petkov wrote:
> 
> > When building pdfdocs, the db2pdf converter bails out because of an
> > latex-reserved token  - '#' - in the intermediary .tex file which ends up in a
> > conversion error with the following error message: 
> > 
> > <log>
> > [15.0.32])
> > ! Incomplete \iffalse; all text was ignored after line 8154.
> > <inserted text>
> >                 \fi
> > <*> kernel-hacking.tex
> > </log>
> > 
> > This is a rather arbitrary fix, so suggest away.
> 
> Hi,
> 
> I don't have a problem with the change, but I don't get that tex error either.
> Here is an extract from the .tex file:
> 
> 
> {\def\Element%
> {451}\def\ProcessingMode%
> {title-sosofo-mode}}\#if\endNode{}\endSeq{}\endLink{}\Seq%
> {}\Leader%
> {}.\endLeader{}\Link%
>
<snip>

Actually this is the TOC-piece of .tex code around line 1622. The offending line
is way down (ca. 8152) at the actual chapter heading and it looks like this:

{\def\Element%
{0:451}\def\ProcessingMode%
{title-sosofo-mode}}\#if\endNode{}\def\HeadingText{%
10.7. \if}%
\endHeadPar{}\endSeq{}\Node%

and I think it is the fourth line that causes the problem for the # sign is
stripped and the title is converted to a tex conditional - \if - which isn't
terminated, but I'm not so sure. The thing is, the docbook2tex converts the
.tmpl file to .tex file ok but db2pdf chokes. What docbook-utils are you using?
Mine are version 0.6.14-1 of debian unstable.

By the way, were you going to send me some kernel-doc todo's...?

