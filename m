Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZKSP5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZKSP5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZKSP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:57:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43451 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbZKSP5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tf4XE4Hb8G7SQm6RPbF8FAtp5yOTSiCAKGFN1lhr1UlnuXBbeOXdDPzOrwZ29zvdLk
         8C2Tet9dsz01d4J41wWenemna9anAQj9BSUoW2IBBo1PavI0YALN1APQoDmdkLR2jlXs
         kpoLWcbuptiYYIuSNfKE95cMzopA+wcXxZ2yI=
MIME-Version: 1.0
In-Reply-To: <4B056A1A.1020609@zytor.com>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
	 <20091119072040.GA23579@elte.hu>
	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
	 <4B0567E0.5080803@redhat.com> <4B056A1A.1020609@zytor.com>
Date: Thu, 19 Nov 2009 16:57:53 +0100
Message-ID: <84fc9c000911190757w42186dav1d3b0141bb6cf79b@mail.gmail.com>
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
From: Richard Guenther <richard.guenther@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Haley <aph@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org, "H.J. Lu" <hjl.tools@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 4:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/19/2009 07:44 AM, Andrew Haley wrote:
>>
>> We're aligning the stack properly, as per the ABI requirements.  Can't
>> you just fix the tracer?
>>
>
> "Per the ABI requirements?"  We're talking 32 bits, here.

Hm, even with

void bar (int *);
void foo (void)
{
  int x;
  bar (&x);
}

gcc -S -O2 -m32 -mincoming-stack-boundary=2 t.c

we re-align the stack.  That looks indeed bogus.

HJ, you invented all this code, what's the reason for the above?

Richard.
