Return-Path: <linux-kernel-owner+w=401wt.eu-S1422702AbXBAXDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422702AbXBAXDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422719AbXBAXDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:03:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6758 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422702AbXBAXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Zr+Lfc3HEB6y3rDkqwc3JX4S+p+wnp3OWz/ORxpfTe9UCKZFTuni9zA7VabKo1VULteztTKS4c1vKNC3c7eViMJJl0YTwbORcDPI1kvHLLzadaGkxfsk6VvP2YHJ7bgKH3r/Pkrv7zQAQS10oYCcm5qG+bDmukcw6A6P9vLZIhk=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Philippe Troin <phil@fifi.org>
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
Date: Fri, 2 Feb 2007 00:00:40 +0100
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <200701272152.11087.vda.linux@googlemail.com> <87bqkhuqpp.fsf@tantale.fifi.org>
In-Reply-To: <87bqkhuqpp.fsf@tantale.fifi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020000.40524.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 04:40, Philippe Troin wrote:
> > int main() {
> >         fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) | O_NONBLOCK);
> >         return 0;
> > }
> > 
> > int main() {
> >         fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) & ~O_NONBLOCK);
> >         return 0;
> > }
> > 
> > If I run "nonblock" in Midnight Commander in KDE's Konsole,
> > screen redraw starts to work ~5 times slower. For example,
> > Ctrl-O ("show/hide panels" in MC) takes ~0.5 sec to redraw.
> > This persists after the program exits (which it
> > does immediately as you see).
> > Running "block" reverts things to normal.
> > 
> > I mean: how can O_NONBLOCK _issued in a process which
> > already exited_ have any effect whatsoever on MC or Konsole?
> > They can't even know that it did it, right?
> > 
> > Either I do not know something subtle about Unix or some sort
> > of bug is at work.
> 
> Because they all share the same stdin file descriptor, therefore they
> share the same file descriptor flags?

What share the same file descriptor? MC and programs started from it?

I thought after exec() fds atre either closed (if CLOEXEC) or
becoming independent from parent process
(i.e. it you seek, close, etc your fd, parent would not notice that).

Am I wrong?
--
vda
