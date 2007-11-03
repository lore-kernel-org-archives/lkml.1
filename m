Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXKCSaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXKCSaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbXKCSao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:30:44 -0400
Received: from smtpoutm.mac.com ([17.148.16.70]:58744 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbXKCSan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:30:43 -0400
In-Reply-To: <20071103164303.GA26707@ubuntu>
References: <20071103164303.GA26707@ubuntu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <45A82524-172E-4F18-B660-981D5A1A6D75@mac.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Date: Sat, 3 Nov 2007 14:30:30 -0400
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 03, 2007, at 12:43:06, Ahmed S. Darwish wrote:
> Bashv3 builtin "echo" behaves very strangely to -EINVAL. It sends  
> all the buffers that causes -EINVAL again in subsequent echo  
> invocations.
>
> i.e.
> echo "Invalid Rule" > /smack/load  # -EINVAL returned
> echo "Valid Rule" > /smack/load
>
> In seconod iteration, echo sends the first invalid buffer again  
> then sends the new one. This causes a "Invalid Rule\nValid Rule"  
> buffer sent to write().
>
> IMHO, this is a bug in builtin echo. The external /bin/echo doesn't  
> cause such strange behaviour.

Actually, what causes problems here is something between a bug and a  
feature in libc's buffering.  Basically the -EINVAL error causes libc  
to leave its data in the file-output buffer despite the file being  
closed and reopened. Since a standalone echo just exits that buffer  
is discarded, but for the bash builtin it hangs around in the buffer  
for a while and ends up getting prepended to the following echo  
statement.  There's actually multiple ways to make this fail; this is  
just the simplest.

Cheers,
Kyle Moffett

