Return-Path: <linux-kernel-owner+w=401wt.eu-S1765792AbYDOUNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765792AbYDOUNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759647AbYDOUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:13:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:42322 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468AbYDOUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YHIBtuBo6tidYaZop7IRvM+BSsswI+1rloHeJ5xzzs3x42jnx7upOIGSVV67xGZPDp8lPLwFxbJRQs9dOWlFr9p5tW+Sr3xTDxdrgHF/uy+Ogj9R0c7NRqIp7aBlAjpaNYocP9kh6+bqK4OI3Boyy1WmqGUQEsS7+m/4hj2av6w=
Message-ID: <ae1c82500804151313h7339b5b1ufc02790544898e50@mail.gmail.com>
Date: Tue, 15 Apr 2008 22:13:08 +0200
From: "Robert Obryk" <robryk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Changing vma's vm_file
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Can a file_ops mmap routine change the vm_file in the vma? I assume
the file_ops of the substituted file won't break -- question is
whether anything else can.

The only thing during mmap syscall I can notice to depend on the value
of vm_file prior to call to f_op->mmap is the whole VM_DENYWRITE
stuff. It confuses me somewhat, while it appears to do something,
while manual for mmap states that MAP_DENYWRITE is ignored. What does
it do now?

The problem I am trying to solve is creating a file which will, upon
being mmaped, duplicate a mapping belonging to a different process. I
plan to do this by substituting vm_file and calling proper f_op->mmap
in my file's f_op->mmap.

Thanks in advance for any advice,
Robert Obryk
