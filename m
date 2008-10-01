Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYJAIhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYJAIhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYJAIg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:36:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:47806 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYJAIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:36:57 -0400
Message-ID: <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com>
Date: Wed, 1 Oct 2008 01:36:55 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used uninitialized
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081001082930.GB31009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001080150.GC25832@elte.hu>
	 <1222849017-10896-1-git-send-email-steven@uplinklabs.net>
	 <20081001082930.GB31009@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 1:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steven Noonan <steven@uplinklabs.net> wrote:
>
>> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
>> ---
>>  drivers/serial/8250.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> the change is obvious to you, but it's useful to put an analysis into
> the changelog. Something like:
>
>  serial_unlink_irq_chain() does not initialize iterator 'i', and that is
>  correct logically because it is always initialized due to XYZ. Gcc does
>  not realize this connection and emits a false warning. Annotate it with
>  uninitialized_var().
>
> and fill in XYZ.
>
> Doing such changelogs is useful to maintainers: they'll see that you
> havent just squashed a warning you noticed, you understood the code and
> determined it via review that the warning is GCC's fault, not the
> kernel's.
>
> with an empty changelog the maintainer will have to do this himself.
> (and can easily put your patch to the tail of a very long TODO list, or
> outright skip your patch.)
>
>        Ingo
>

I was kind of worried about being exceedingly verbose, but I
understand your point perfectly. I'm going to resend the patch with an
appropriately verbose comment.

As always, I appreciate the criticism. Thank you! :)

- Steven
