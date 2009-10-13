Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbZJMI6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbZJMI6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZJMI6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:58:40 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:48716 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZJMI6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GksrVc6zcA37HiqkxJEg5/x30YU497BxKgDLEZlQTXz5xI2gYZfeaIC4rrSjN+lOYe
         FO8K7Vveg/y+RUwuGtJw3frE486Rj0UW4QS1IJDnN3UWTseTO5MFiWpVDKWBKsHlHdu0
         FfvE1FHnqiEAYmPwF8gfB+noY9oeIaqklaseY=
MIME-Version: 1.0
In-Reply-To: <19156.16146.326389.380625@pilspetsen.it.uu.se>
References: <f22d86810910130037x48cac5c1s8928a6ff49dda381@mail.gmail.com>
	 <19156.16146.326389.380625@pilspetsen.it.uu.se>
Date: Tue, 13 Oct 2009 14:28:02 +0530
Message-ID: <f22d86810910130158u73c2f669wa129fa4e8d48b521@mail.gmail.com>
Subject: Re: Using intptr_t and uintptr_t in Kernel
From: "Leonidas ." <leonidas137@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 2:19 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Leonidas . writes:
>  > I know variants of this questions have been asked on this list before,
>  > but I could not
>  > find a thread where a conclusion was reached, most of the time
>  > responses were { I don't care,
>  > developer's choice, might be in future } and variations thereof. But
>  > one thing was clear
>  > that do not mix userspace and kernel space data types.
>  >
>  > Currently, I am porting a user space application to kernel, this app
>  > uses intptr_t data type.
>  >
>  > A look at linux/types.h shows that,
>  >
>  > typedef unsigned long           uintptr_t;
>  >
>  > but intptr_t is not defined at all. Also, isn't above definition
>  > incorrect?
>
> No, it's correct because Linux requires sizeof(void*) == sizeof(long).
>
>  > Since the whole idea
>  > behind uintptr_t is to store pointer in a int sized variable,
>
> uintptr_t will use _some_ integer type, not necessarily 'int'.
>
> If ISO C said 'int' there would be no need for {,u}intptr_t.
>
>  > are we
>  > not assuming here that
>  >
>  > sizeof(int) = sizeof(unsigned long ) on all archs?
>
> No, see above.
>

Thanks, for the response, but frankly I am still confused.
Let me recollect my thoughts in more concise manner.


User space documentation for C99, http://linux.die.net/man/3/intptr_t says,

typedef unsigned int uint16_t
typedef uint16_t uintptr_t

and http://lxr.linux.no/#linux+v2.6.31/include/linux/types.h#L41 says,

typedef unsigned short __u16;
typedef         __u16           uint16_t;

i.e. kernel space mean 16 bits when it says u16 but gcc does not mean
the same thing.
So if a programmer meant uintptr_t in userspace he means store the
pointer in a datatype
which is as big as uint16_t i.e. unsigned int. So hold the pointer in
an unsigned int.

In kernel space if we go by the data type definitions, we would get a
pointer of size __u16
which is an unsigned short, the programmer did not intend this, right?


-Leo.
