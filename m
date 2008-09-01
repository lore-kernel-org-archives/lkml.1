Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYIAKiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYIAKiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 06:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYIAKiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 06:38:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:19598 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYIAKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 06:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=vwJqR3BHhJFbCMYKHcT+Pji8Mi9X1IdhdYbXKYIMq6vY9/lVC/eKk1D7cGDUZqCy3G
         6fKWYslRN0IEGEa1bw4B7gwFSInYwutzBcEbI1WIC5eni3MN9tbE4R6i42j/ncCO4Qzv
         jf3PFdXcj+gysBBCXB/vw/essXfKk/9q4+5wQ=
Message-ID: <5ff4a1e50809010338o77fffec4w625ed48b3987d51@mail.gmail.com>
Date: Mon, 1 Sep 2008 11:38:15 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: ktime_set() does not check for nanoseconds > one second
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is it intentional that ktime_set() does not check whether the
nanoseconds argument is greater than the number of nanoseconds in a
second? I've run into a problem where a value of 1600000000
nanoseconds was passed as an argument to ktime_set() and the return
value was then used in a ktime_add() call, which returned an incorrect
result. Should the caller of ktime_set() make this check or is it
possible to move this logic in to the function itself?

Matt
