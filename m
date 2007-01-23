Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXAWScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXAWScU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 13:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXAWScU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 13:32:20 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:32520 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbXAWScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 13:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DgFZ2xNCbmCMIHzvvDxSGTzCpCtk9QGRwylI4FFBKsyxj0x3FdbzN4lDabjujw49LQrYHDLFpZP2ptmptXNPstfj61yvguXzljeOmaUMaigabm6cG/PyO04E+HkjD63T/L52Xk7cfiQ0olAbOFS02kJtTUnKGrRni7KuLP7wHRg=
Message-ID: <4ae3c140701231032xd6eca27td46cc1c25e150e25@mail.gmail.com>
Date: Tue, 23 Jan 2007 13:32:17 -0500
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Is it possible to directly call do_path_lookup() in kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to call the following code in a kernel module:

	error = do_path_lookup(AT_FDCWD, "/etc/profile.d/glib2.csh",
LOOKUP_PARENT, &nd);

I exported the function do_path_lookup() using
"EXPORT_SYMBOL_GPL(do_path_lookup);"

But do_path_lookup() caused the "general protection fault: 0000 [#1]"
kernel error.

I thought it could be the problem of protection error, so I used the
following codes to enclose the code that calls do_path_lookup(), but
still got the same error.

	fs = get_fs ();							  /* save previous value */
	set_fs (KERNEL_DS);						  /* use kernel limit */
        ......
        set_fs(fs);

Any idea on this?

Thanks a lot!

-x
