Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZKMV0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZKMV0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZKMV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:26:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55783 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbZKMV0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:26:17 -0500
Date: Fri, 13 Nov 2009 22:26:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Valdis.Kletnieks@vt.edu
Cc: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: <19857.1258147396@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0911132224370.6325@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
 <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com>
 <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com>
 <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org>           
 <4AFCC06B.1030302@schaufler-ca.com> <19857.1258147396@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, Valdis.Kletnieks@vt.edu wrote:

> On Thu, 12 Nov 2009 18:11:55 PST, Casey Schaufler said:
> > James Morris wrote:
> > > Do you see potential for a buffer overrun in this case?
> 
> > No, but I hate arguing with people who think that every time
> > they see strcmp that they have found a security flaw.
> 
> How do you feel about people who think every time they see strcmp()
> "Oh crap, something that needs auditing"? ;)
> 
> The biggest problem with strcmp() is that even if it got audited when that code
> went in, it's prone to unaudited breakage when somebody changes something in
> some other piece of code, quite often in some other .c file in some other
> directory.
> 
> Julia, is there a way to use coccinelle to detect unsafe changes like that?  Or
> is expressing those semantics too difficult?

Could you give a concrete example of something that would be a problem?
If something like alias analysis is required, to know what strings a 
variable might be bound to, that might be difficult.  Coccinelle works 
better when there is some concrete codeto match against.  But it is 
possible to eg match functions that have a certain property of their 
return value, or to collect all of the values that are stored in a 
structure field.

julia
