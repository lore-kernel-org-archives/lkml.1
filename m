Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZCAXlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZCAXlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbZCAXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:41:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:54514 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZCAXlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rakAKc5g1vTU8AhsYKlv0DoI+eskwPlujsznd/zS1XewduhLuXWjGK1kG3SZ7hh6Dg
         lW5QCCPBpAvtqdBP4Khvq8/+irb6DRiE9mT1XCRvesmYiFBSU0gfAlQiRLdtS3tMc7rY
         UiLgwpVQ0Ul9kdnm5Xo42MrXxBxNn9VrBW85A=
MIME-Version: 1.0
In-Reply-To: <49AB12A7.10708@gmail.com>
References: <49AB12A7.10708@gmail.com>
Date: Sun, 1 Mar 2009 20:41:38 -0300
Message-ID: <82ecf08e0903011541y32f74656uc33dc08a2c2a5fa0@mail.gmail.com>
Subject: Re: lp: too large subtraction on unsigned?
From: Thiago Galesi <thiagogalesi@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doesn't look like something is wrong, or I'm missing something...
:
> do {
>        if (canwrite > 0) {
>                ...
>                count -= written;
>        }

If there are chars left you write to the PP and take it out of the total

>        if (lf && canwrite <= 0) {
>                ...
>                count--;
>                ...
>        }
> } while (count > 0 && (CONSOLE_LP_STRICT || written > 0));

The second if is for translating \n to \r\n only if you've already
written everything (up to /n) to the PP

If count > 0 fails (that is, count == 0) you get out of the loop

-- 
-
Thiago Galesi
