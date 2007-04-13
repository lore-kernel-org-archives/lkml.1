Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXDMPSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXDMPSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXDMPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:18:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27684 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbXDMPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:18:07 -0400
Date: Fri, 13 Apr 2007 08:20:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] fix tex error when building pdfdocs
Message-Id: <20070413082049.adbc611d.randy.dunlap@oracle.com>
In-Reply-To: <20070413063459.GA4075@gollum.tnic>
References: <20070412203842.GA14245@zmei.tnic>
	<20070412164851.0c5d6e54.randy.dunlap@oracle.com>
	<20070413063459.GA4075@gollum.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 08:35:00 +0200 Borislav Petkov wrote:

> On Thu, Apr 12, 2007 at 04:48:51PM -0700, Randy Dunlap wrote:
> > On Thu, 12 Apr 2007 22:38:42 +0200 Borislav Petkov wrote:
> > 
> > > When building pdfdocs, the db2pdf converter bails out because of an
> > > latex-reserved token  - '#' - in the intermediary .tex file which ends up in a
> > > conversion error with the following error message: 
> > > 
> > > <log>
> > > [15.0.32])
> > > ! Incomplete \iffalse; all text was ignored after line 8154.
> > > <inserted text>
> > >                 \fi
> > > <*> kernel-hacking.tex
> > > </log>
> > > 
> > > This is a rather arbitrary fix, so suggest away.
> > 
> > Hi,
> > 
> > I don't have a problem with the change, but I don't get that tex error either.
> > Here is an extract from the .tex file:
> > 
> > 
> > {\def\Element%
> > {451}\def\ProcessingMode%
> > {title-sosofo-mode}}\#if\endNode{}\endSeq{}\endLink{}\Seq%
> > {}\Leader%
> > {}.\endLeader{}\Link%
> >
> <snip>
> 
> Actually this is the TOC-piece of .tex code around line 1622. The offending line
> is way down (ca. 8152) at the actual chapter heading and it looks like this:
> 
> {\def\Element%
> {0:451}\def\ProcessingMode%
> {title-sosofo-mode}}\#if\endNode{}\def\HeadingText{%
> 10.7. \if}%
> \endHeadPar{}\endSeq{}\Node%
> 
> and I think it is the fourth line that causes the problem for the # sign is
> stripped and the title is converted to a tex conditional - \if - which isn't
> terminated, but I'm not so sure. The thing is, the docbook2tex converts the
> .tmpl file to .tex file ok but db2pdf chokes. What docbook-utils are you using?
> Mine are version 0.6.14-1 of debian unstable.

I'm using:  docbook-utils-0.6.14-79  (SLED 10)

and the corrected :) lines contain an additional '#':

{1}}10.7. \Node%
{\def\Element%
{451}\def\ProcessingMode%
{title-sosofo-mode}}\#if\endNode{}\def\HeadingText{%
10.7. \#if}%
\endHeadPar{}\endSeq{}\Node%
{\def\Element%
{451}}\endNode{}\Node%



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
