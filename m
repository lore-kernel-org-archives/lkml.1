Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZLHPCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZLHPCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZLHPCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:02:40 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:34157 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbZLHPCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:02:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FeA8ozmMoV72OlcNuAstzC2+GyaFHW/IfuQ8FqL6tSxtD4YxPDJOJ2DaYwKr95P0po
         ij/goLwSFWTDtKQc7hV8hmIi16GHulK4+qiUo78u680jRjLxQTk421cHqY6ZY/cL9SeX
         fL90O2DXpl88sJXu9c+L+fmlbZgWsnQxKHQK0=
MIME-Version: 1.0
In-Reply-To: <4B1E2626.9010005@redhat.com>
References: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>
	 <20091201154412.4002a0d8@linux.intel.com>
	 <4B177878.2090002@redhat.com>
	 <20091203111329.3558ea39@linux.intel.com>
	 <4B1E2626.9010005@redhat.com>
Date: Tue, 8 Dec 2009 08:02:43 -0700
X-Google-Sender-Auth: a6167fb82bee84ae
Message-ID: <fd3b2d10912080702l313c4e39p2ce98b93a3ae494@mail.gmail.com>
Subject: Re: [Patch] tty: move a definition out of switch block
From: Joe Peterson <joe@skyrush.com>
To: Cong Wang <amwang@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 03:10, Cong Wang <amwang@redhat.com> wrote:
> Well, in C99 6.5.4, it has a very good example to explain this.
> See this example:
>
> switch (xxx) {
>        int a = 1; //<-- not initialized
>        int b; //<-- seems to be skipped, but not
>        func(&a); //<-- skipped;
> case 1:
>        //...
>        break;
> case 2:
>        return a; //<-- uninitialized value;
> }

I agree there are some strange semantics within switch statements
regarding what happens to lines before the first "case", but nothing
about declaring variables there is illegal, and the behavior is
well-defined.  Yes, statements and initializers get skipped, but the
variables are still declared.  Neither "int a" nor "int b" above are
skipped or even "seem skipped"; it is only that the initialization of
a is not performed.  Declarations (that to not initialize) are just
declarations; they do not get "executed".  Putting them at the start
of a switch block simple shows that they exist in that scope.

> So why not just:
>
> int a = 1, b;
> switch (xxx) {
> case 1:
>        // blah blah
> }
>
> ? A first galance will know everything, no need to guess if
> 'switch' skips it or not.

Main reason: variables is used only within scope of the switch
statement.  Sure, it could be moved outside, but I'm not convinced
this is vital or proper or even more clear.  It would be a bug to try
to initialize such a variable or to try to execute statements at the
start of the switch block, but this is not being done.

-Joe
