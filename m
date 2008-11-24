Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYKXOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYKXOj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYKXOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:39:47 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:58684 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYKXOjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZOCghvi9lsvDDAUcjJJJKsBWH6/OIk71zUJ9Fxsh1hfpgsbXR/Pnvrhg+L2E6YOKsx
         pUZEAxSlrYHSnGsxUzrivOIXJXg+mXueWT0puZU7l4n5Vd1hh+sfZjPeYx7i8uVi43IQ
         LAtNtqdDWfk4O3KMEU2CZmIgMrs7V4QUbYe7Y=
Message-ID: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
Date: Mon, 24 Nov 2008 15:39:45 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
Subject: Human readable output for function return tracer
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm planning to apply an idea proposed by Ingo to make the output on
the function return tracer
more "eyes-parsable".
The idea consists on a trace which has flow similar to C code:

func1() {
    func2() {
        func3() {
        }
    }
    func4() {
    }
}

(With time of execution added on closing braces).

The problem is that the traces arrive in the reverse order, according
to the fact that functions
are traced on return.
The order corresponding to the above example would be as the following:

func3, func2, func4, func1

Oh and we have the parent in a return trace, so we would actually have:

func2->func3
func1->func4
....    ->func1

This trace flow doesn't make the things easy to produce our C like code.

So I found only one solution which have both pros and cons.
I could send a "pre-trace" to the ring-buffer to signal that function
x with depth y is beeing called
(when we enter the function).

The pros:

_ It will be easy to draw our C 'like trace, without any special
pre-output work.
_ The name could be definetly full-function-tracer with this new pre-trace :-)
_ Automatic trace parsing, tree of calls building will be more easy....

The cons:

_ The function-return-tracer slows down the system.
   It will be worst with a new insertion in the ring-buffer. But if it is mostly
   used with dynamic ftrace and a good set of filtered functions, I
don't think that will be
   an issue.

If you think about an other solution, don't hesitate to tell me :-)
Thanks....
