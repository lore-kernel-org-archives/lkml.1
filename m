Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYEMGrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYEMGrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbYEMGrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:47:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:15623 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYEMGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ig6931v3pXJxJk8QRzH9tpHS2Nr0vZwQkPuCzlW6tCkkawdMKe5cPBrgrWgDQASqKV3l3GaMDiA/i8rD9CSMnCGXF1Qbyyh068YnYwh6uSx4UfJDmojS8c3btyRdOSKBu8HM8R+TYtGMaLJKp0yHalXTG6IKbktuEdDukykUDwQ=
Message-ID: <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
Date: Tue, 13 May 2008 08:47:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4829326A.6060808@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4829326A.6060808@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 13, 2008 at 8:17 AM, Harald Dunkel
<harald.dunkel@t-online.de> wrote:
> Hi folks,
>
>  I haven't seen it mentioned here (hopefully I wasn't too blind to see):
>
>  If I run "su someuser" as root, then it gets stuck. No prompt. I cannot
>  interrupt it with ^C or ^Z either. /var/log/auth.log says:

...

>  So obviously 'stty' is to blame here (called from root's .bashrc, as
>  it seems). But for 2.6.24.4 there is no such problem.
>
>
>  Maybe you could spread some light here?

Can you try to run "strace su someuser" instead?

This should produce some screenfulls of information, but will also
pinpoint the location of the hang in userspace if it's an error
somewhere in the path of a system call. Strace will output to stderr,
so use 2>strace.txt to capture it to a file. If you do this as root,
you should not have to enter any passwords, so they won't be logged
either.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
