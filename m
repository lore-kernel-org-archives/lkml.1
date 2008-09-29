Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYI2P5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYI2P5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYI2P4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:56:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:61593 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYI2P4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GNKforVxE+Z9xXCf3yLbPOAG6gEYrqV7OiuCJSFrGS3IIlzaC+HY/qLKrz5IzrM9e0
         xaXgH0vY90w0R3ICR8GexCi0YjIWs4sDNhUZiCtfgTMBiwOp/KB/rcC+4ijLvI5Y33k7
         jOkt5BDxCMiASaZy+zFN6Q+wsYrJGKbomdbXc=
Message-ID: <c62985530809290856w4045c3acx8779d8a11445a14a@mail.gmail.com>
Date: Mon, 29 Sep 2008 17:56:50 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Path -tip 1/3] Tracing/ftrace: Change the type of the print_line callback
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080929180409.68cdf8ba@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48DCFEE1.4010102@gmail.com>
	 <20080928191918.1b26c0ab@daedalus.pq.iki.fi>
	 <c62985530809290211l7df01459lf80456ab98fc6ed0@mail.gmail.com>
	 <20080929180409.68cdf8ba@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/29 Pekka Paalanen <pq@iki.fi>:
> On Mon, 29 Sep 2008 11:11:15 +0200
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
>
>> 2008/9/28 Pekka Paalanen <pq@iki.fi>:
>>
>
> [static int print_trace_line(struct trace_iterator *iter)]
>
>> > Shouldn't the return type be bool?
>> > If it's not, reading this function makes me wonder about the conversion
>> > from enum to int, i.e. what is the meaning of the int.
>>
>> Actually it should be enum print_line_t. I forgot to change its type.
>> But we need to check its return value as an enum print_line_t.
>
> Is print_line_t necessary? Does it have to return any other information than
> "this entry was handled somehow" vs. "this entry must be handled later"?
> Currently it's just a flag to say "please flush and retry".


It would just make the code more readable in the read_pipe function.
if (sret == TRACE_TYPE_PARTIAL_LINE) tells us more than if (!sret).
And it would avoid some tests to return a boolean in print_trace_line.

No?
