Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbZFLQz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbZFLQz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFLQzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:55:18 -0400
Received: from claw.goop.org ([74.207.240.146]:50909 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZFLQzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:55:18 -0400
Message-ID: <4A328873.4000802@goop.org>
Date: Fri, 12 Jun 2009 09:55:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/paravirt: clean up paravirt.h and optimise FPU
 context switch
References: <1244748040-27185-1-git-send-email-jeremy@goop.org> <20090612112933.GA14930@elte.hu>
In-Reply-To: <20090612112933.GA14930@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/09 04:29, Ingo Molnar wrote:
> I havent checked all headers but do we now use the principle that we
> only include paravirt_types.h into other headers - and paravirt.h
> only into .c code that makes use of methods?
>    

No, not really.  The headers which currently define the native versions 
of the inline functions  need to include paravirt.h (as they currently 
do).   In fact, there are very few places which actually care about the 
definitions in paravirt_types.h as opposed to the inline functions; the 
main reason for the split was to do make paravirt tracing possible (but 
that's not ready yet, as we haven't come to a satisfactory conclusion 
about the rcu include in tracepoint.h).

     J
