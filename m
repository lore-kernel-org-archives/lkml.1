Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZFPOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZFPOyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZFPOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:54:13 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:55533 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZFPOyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AgsdvVli8dgK3XyGSbKMK7ELZkO7X+su/F27F59iZF4SGYdZS+KaQWSSsaRvx2pio8
         0eleXspHbTlgAQxM1nVyM2ckSlUheQqG87r8sBvjEuPfFFMpkzq9ENSE8fnLEZPmMQgE
         CzTw4BkGE1YE79E7fJIsiDcOe/PJu7+O9FnOg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0906082208430.6439@bogon>
References: <alpine.DEB.2.00.0906021141010.19390@bicker>
	 <87iqjedf2a.fsf@basil.nowhere.org>
	 <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
	 <alpine.DEB.2.01.0906082208430.6439@bogon>
Date: Tue, 16 Jun 2009 16:54:15 +0200
Message-ID: <a63d67fe0906160754ub38679ag9493d5090a9ca0c0@mail.gmail.com>
Subject: Re: smatch 1.53 released
From: Dan Carpenter <error27@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/09, Christian Kujau <lists@nerdbynature.de> wrote:
> On Thu, 4 Jun 2009, Dan Carpenter wrote:
>>> Smatch is a source code checker for C.  Right now the focus is on
>>> checking
>>> for kernel bugs.
>
> Hm, smatch is pretty noisy. I'm getting hundreds of warnings and errors on
> a randconfig build: http://nerdbynature.de/bits/smatch/
>
> False positives or real issues?
>

If it´s not in drivers/ it´s a false positive.  Otherwise there is a
95% chance it is a false positive.  In an ideal world there would be
no bugs and no false positives.  But it´s easier to fix the bugs
smatch reports than to fix smatch so probably eventually it will be
100% false positives.

Quite a lot of the time, I don´t know the code well enough to say
whether a bug is a false positive or not.  Check the bits that you
care about.  The smatch output format is designed for vim.  "vim
filename.c +lineno"

If there was some way to get rid of the "field" messages that would
reduce the false positive count by 20.
kernel/trace/trace_functions_graph.c +808 print_graph_function(14)
error: dereferencing undefined:  'field'
I don´t see a heuristic to do that.

The rest are smatch bugs.  Code like:
foo->bar = NULL;
foo = frob();
foo->bar->baz = x;  // smatch thinks this is a bug since foo->bar was
set to NULL.

Sometimes running smatch with the --debug option can help to find
where smatch gets it wrong.  kchecker also takes the --debug option.

regards,
dan carpenter

> Thanks,
> Christian.
> --
> BOFH excuse #182:
>
> endothermal recalibration
>
