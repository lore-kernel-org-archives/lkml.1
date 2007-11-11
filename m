Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbXKKXlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbXKKXlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 18:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbXKKXkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 18:40:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:14841 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXKKXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 18:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EyBulRvL7weELPzKV7BYhwiLEoI67TyGEqzKkwalRolrN2tlP7EToNHotWxG26WshWvryT2HXgYuaG+BPN5G/wdSUKKSWekkKpWSG5vXWNlmGd6zNeJyiaclR67m1MA3LCbFKLXupWIRP7e/y/iIVHb0CfR12JMfod7RVGLVlCc=
Message-ID: <9a8748490711111540q10503eday7f06b3e72b20fe82@mail.gmail.com>
Date: Mon, 12 Nov 2007 00:40:53 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: mm_release() call in exit_mm() looks dangerous
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/exit.c we have this code :

static void exit_mm(struct task_struct * tsk)
{
        struct mm_struct *mm = tsk->mm;

        mm_release(tsk, mm);
        if (!mm)
                return;
...


But, mm_release() may dereference it's second argument ('mm'), so
shouldn't we be doing the "!mm" test *before* we call mm_release() and
not after?
I don't know the mm code well enough to be able to tell if some of the
other stuff mm_release does needs to be done always and the mm
dereference can't actually happen, but maybe someone else who knows
the code better can tell...  In any case, what's currently there looks
a little shaky..

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
