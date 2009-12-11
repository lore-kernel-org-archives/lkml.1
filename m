Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZLKLcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZLKLcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762371AbZLKLcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:32:35 -0500
Received: from icdsoft.com ([64.14.68.165]:54723 "EHLO us.icdsoft.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762230AbZLKLc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:32:26 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 06:32:26 EST
Message-ID: <4B222C3D.2070807@icdsoft.com>
Date: Fri, 11 Dec 2009 13:25:49 +0200
From: Ivan Zahariev <famzah@icdsoft.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ivan Zahariev <famzah@icdsoft.com>
Subject: EUID != root + EGID = root, and CAP_SETGID
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Currently, if a process is started with EUID which is non-root, and EGID 
which IS root (for example by set-group-ID file permission + file group 
owner "root", or an account in /etc/passwd with group=0), then the 
processes is not granted CAP_SETGID.

As a result, such a process cannot change its EGID to an arbitrary one, 
even though the current EGID is the super-user "root" one. Therefore, 
such a process cannot easily drop its EGID "root" privileges to non-root 
ones, for security reasons.

This is not the case if the process starts with EUID=0. Then the 
processes is granted *both* CAP_SETUID and CAP_SETGID.

Is this an intended behavior? Shouldn't a process which is started with 
EGID=0 get CAP_SETGID too?

Thank you.

Best regads,
Ivan Zahariev

P.S. For more detailed info: 
http://blog.famzah.net/2009/12/11/linux-non-root-user-processes-which-run-with-group-root-cannot-change-their-process-group-to-an-arbitrary-one/
