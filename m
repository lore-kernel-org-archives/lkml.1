Return-Path: <linux-kernel-owner+w=401wt.eu-S1945965AbXBIA6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945965AbXBIA6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945966AbXBIA6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:58:20 -0500
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:36989 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945965AbXBIA6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:58:19 -0500
Message-ID: <45CBC71F.30607@ubiqx.mn.org>
Date: Thu, 08 Feb 2007 18:58:07 -0600
From: "Christopher R. Hertel" <crh@ubiqx.mn.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Shirish S Pargaonkar <shirishp@us.ibm.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-cifs-client-bounces+shirishp=us.ibm.com@lists.samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: SMB support still missing?
References: <OFCB86D528.05DE4D00-ON8725727D.000397BF-8625727D.0003B058@us.ibm.com>
In-Reply-To: <OFCB86D528.05DE4D00-ON8725727D.000397BF-8625727D.0003B058@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shirish S Pargaonkar wrote:
:
> This is what Steve had mailed me once, a while ago....
> 
> Win9x and Windows ME and OS/2 only listen on port 139
> 
> WindowsNT 4 (?) and later listen on port 445 and port 139.
> 
> When you connect on the older port 139, you are supposed to send a
> RFC1001 (NBSS Session Request to indicate your client netbios name, but
> the problem is that you don't know the target netbios name of the server
> - which is why the either needs to support the fake name "*SMBSERVER" or
> the client needs to specify the "servernetbiosname=<name>" option on
> mount to identify which name on the server to try to connect to.
> 
> So
> 1) try tcp  connection on  445,
>     then if it works send SMB negprot
> 2) else try tcp connection on port 139
>     then if it works send nbss request to *SMBSERVER or to the name
> specified on servernetbiosname
>     (cifs really should do an ASTAT command and list the valid names and
> find one if that approach fails but we don't have code for this yet)

This is all correct, and also note that W/9x systems do not support the
"*SMBSERVER" name.

On the other hand, the name was resolved somehow.  The typical work-arounds
to not knowning the NBT name of the server are:
1) Use the name you just resolved (in this case, "CL0").
2) Send a Node Status Query and look for the first unique <20> name.

The second (as Steve explained to me a long time ago) is less reliable
because there are some applications out there which (incorrectly) register
names with a suffix byte of <20>.

Chris -)-----

-- 
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, uninq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh@ubiqx.mn.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh@ubiqx.org
