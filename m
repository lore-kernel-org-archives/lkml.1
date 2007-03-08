Return-Path: <linux-kernel-owner+w=401wt.eu-S1030275AbXCHIjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbXCHIjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030268AbXCHIjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:39:51 -0500
Received: from ip33.server2.digitalinet.com ([66.235.184.33]:50088 "HELO
	server2.digitalinet.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1030293AbXCHIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:39:51 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 03:39:50 EST
Message-ID: <15429.83.60.135.204.1173342736.squirrel@webmail2.digitalinet.com>
Date: Thu, 8 Mar 2007 09:32:16 +0100 (CET)
Subject: Request change in behaviour of capability inheritance.
From: rgarcia@kotasoft.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think that the current behaviour of capability inheritance across exec()
is not optimal.

The current behaviour consists in all effective and permitted capabilities
are cleared across a exec(). This is because it seems to be intended that
in the future the executable files have a set of "allowed" and "forced"
capabilities.  If a capability is not allowed, it is not permitted in an
inherited process. But at pressent, there is no attribute of "allowed"
capabilities in the filesystem, and the behaviour is that no capability is
allowed.

I request to change this behaviour. By default all capabilities should be
allowed, that is, inherited across exec().

This is neccessary to protect a daemon without changing its source. With
the requested behaviour, it would be posible to launch a daemon intented
to run as root, as an unpriviledged user but with the neccessary
capabilities, by using a script or program that changes the uid and the
capabilities and then launches the daemon.

Thus the present behaviour of no "allowed" capabilities pretends to be
more secure, but is actually less secure. By default, all parent
priviledges should be inherited, because this allows one to create
programs and scripts that execute daemons or other programs in a
restricted environment.

I am modifying kernel source for our own setup. I think others should


----------------------------------------------
Ramon Garcia Fernandez
Kotasoft, your experts in Linux consulting
----------------------------------------------
