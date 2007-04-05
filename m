Return-Path: <linux-kernel-owner+w=401wt.eu-S1767008AbXDEOgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767008AbXDEOgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767005AbXDEOgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:36:39 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:18878 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767008AbXDEOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kQvfHP31hU+TY7RvKwqg0h9EtwYxd/VfmyCYVHRchaYnAxuJpcw1OBucF13SK3tCEUCaRFBH67iAs/eCtS4kmFULY1FnNgv9bje/DvkIT1+btCNXDPnBVUaqPCskBuTW6/0Lmst89wvfXeP3oYF9VBLLY4tLBYB49N1BZ4a14L0=
Message-ID: <26d2cb010704050736y775b6b09g67fd40344cd2208d@mail.gmail.com>
Date: Fri, 6 Apr 2007 00:36:36 +1000
From: "leon zadorin" <leonleon77@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: "no hz"/"dynamic tick" option and TC/TBF (token bucket filter) behaviour...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

two questions for you:

 1) the "no hertz" or "dynamic tick" feature in the kernel - which (if
any) kernel releases use it as a default option?

 2) for kernels which do have the aforementioned option enabled: how
does this affect the "tc" (traffic control) utility and the Token
Bucket Filter (tbf) queueing discipline (traffic-smoothing)
behhaviour?

 For example, the TBF doco suggests that due to the whole fixed Hz
thing in the kernel (e.g. 100Hz) the maximum rate of the TBF would
actually be limited to say 1mbit on Intel arch (with the default
mtu... but if mtu is incleased, so is the burstiness of the traffic
which is what TBF is trying to prevent in my deployment scenarios).
...

 So what about the kernels which use this "dyna tick" option - in such
a kernel, will there be an interrupt generated (e.g. at microsec.
precision on most platforms) for every packet's send time (e.g. say at
TBF's rate is at 25Mbps and one sends out 1KB data packets... will
there be  an interrput generated every... 300 microseconds?)...

 I guess I am asking this as it will be have consequences on what to
set the "mtu/minburst" values for tbf running with "no hertz"
feature... I am developing this "bursty" traffic, DV/HDV transmission
application (over UDP) and need to smooth frames as big as 400KB in
size no to be sent out at "wire" speed... (ideally they need to be
sent out "as smooth as possible")

 I know that there is a PSP (Precise Software Pacer) developed by
GridMPI people, but it would be nicer to get this sort of thing done
with the "default" kernel's disciplines (as PSP is a kernel module
which needs to be compiled [a process that uses "/opt" directory and
requires exactly matched iproute2 sources, etc... - in other words not
an explicitly standard and "stright-forward" process for the end-user
to follow] which adds more complexity to end-users' installation... as
well as PSP not supporting TCP segmentation offloading meaning that
other apps running on the same machine will not get the benefit of TCP
offloading processing)...

 Kind regards
 Leon.
