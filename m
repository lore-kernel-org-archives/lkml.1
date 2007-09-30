Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbXI3Q3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbXI3Q3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXI3Q3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:29:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:24987 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXI3Q3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SCB/uHRwnbeIjIpO6lfe6hJvzCQurdjr1wwr2DLGyrccJNTJZViU4RKfs2mSRETeujy7naTSLXiZ9cSa4/OKOJlrvBbqJItZEtfPSEwhxMDRxSsXP8jRQwwBo2JHCJ72I1ocC4dF2ThKz2Mwt70Eb17ymrlAv97oqgF94k/UBO4=
Message-ID: <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>
Date: Sun, 30 Sep 2007 19:29:35 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Neil Romig" <neil@romig.demon.co.uk>
Subject: Re: File corruption when using kernels 2.6.18+
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46FFC371.9040805@romig.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FFC371.9040805@romig.demon.co.uk>
X-Google-Sender-Auth: 50c45bc45d7f13eb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 9/30/07, Neil Romig <neil@romig.demon.co.uk> wrote:
> I would suspect a memory problem but memtest86+ gives no errors despite numerous
> passes, and I get no errors in older kernels. Does anyone have any idea what changed in
> 2.6.18 to cause such an error?

I don't but you can try to isolate the changeset introducing the
corruption with git-bisect:

http://kernel.org/pub/software/scm/git/docs/v1.3.3/howto/isolate-bugs-with-bisect.txt

So, in your case, you do:

<clone Linux mainline git repository>
# git bisect start
# git bisect bad v2.6.18
# git bisect good v2.6.17

then

<recompile and test>
<git bisect [good|bad] depending on results>
<repeat until you've narrowed down the changeset>

Also, please remember to send your .config when reporting bugs as
described in REPORTING-BUGS.

                                         Pekka
