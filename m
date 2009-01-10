Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZAJHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZAJHSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 02:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZAJHSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 02:18:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:36225 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZAJHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 02:18:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k374RrXdkZ39sIajqMde2JD/DsH9dajOzz0NIsOaLrCAuU2kBylZW7qGdMrp89xZf0
         1wBm09orwn+1ZR93LFwHax+qcv6Y1a5GbRZW7DWTru/k5B8wWD0zOXZmwf8kmfRXx1Nm
         wlofE7sAge82oRNvrWYwRA/kQdzZJsQwinxtU=
Subject: Re: [PATCH] Disable branch profiling macros when sparsed.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: alexey.zaytsev@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rostedt@goodmis.org
In-Reply-To: <20090109.221348.166902734.davem@davemloft.net>
References: <20090110052727.5471.3654.stgit@zaytsev.su>
	 <20090109.221348.166902734.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 23:18:26 -0800
Message-Id: <1231571906.5714.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 22:13 -0800, David Miller wrote:
> From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> Date: Sat, 10 Jan 2009 08:57:28 +0300
> 
> > The macros produce lots of unneeded warnings when
> > recursive if(({ .. if() {..} ..})) {..} and such
> > are substituted. And there is no point in sparsing
> > them anyway. This is useful if someone decides to
> > sparse an allyesconfig kernel.
> > 
> > Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> 
> If even sparse can't handle these things, it's no surprise
> how many gcc bogus warning problems we've run into because
> of this hairy if() macro.

It's not that sparse can't handle it, the warning is valid,
_____r and ______f are shadowed when these get nested.  It
gets even worse when interacting with likely/unlikely tracing
as that chose the same identifiers too.  So there the noise
could be drastically reduced changing the different identifiers
for the if () and __branch_check macros, but nesting will always
warn.

I've just been setting this to no in my allyesconfig sparse
runs....just wait until kmemtrace gets to mainline, then it
gets really bad :(

Cheers,

Harvey

