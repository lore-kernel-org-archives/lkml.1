Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbXGXGjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbXGXGjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXGXGjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:39:45 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:39239 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbXGXGjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:39:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:X-Enigmail-Version:OpenPGP:Content-Type;
	b=jD9RoNVY3YFLnMtiqvUevJcz4SPKfHifPsWTJITPBKug02sM62jCwahSdkD6d7I5po9ZNLUPVWjch8DUOEKvGb1ZOfcHsdoIUlWosIgH4xekO0eDKToS46WhQHr7dwV/;
Message-ID: <46A59EAA.9030105@simon.arlott.org.uk>
Date: Tue, 24 Jul 2007 07:39:38 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cornelia.huck@de.ibm.com
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: sysfs/udev broken in latest git?
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: multipart/mixed;
 boundary="------------030208080509070402080808"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030208080509070402080808
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The following commit appears to break some of my udev rules (I don't 
have the time to finish the bisect right now, but there's only four 
changes showing in "git bisect visualize" - this one is tagged 
bisect/bad, and the other three are docs/docs/unrelated).

Neither of these symlinks get created by udev on kernels marked bad 
(see bisect log below):

ACTION=="add", \
        KERNEL=="event*", \
        SUBSYSTEM=="input", \
        SYSFS{description}=="i8042 KBD port", \
        NAME="input/%k", \
        SYMLINK="input/i8042-kbd", \
        MODE="0640", \
        GROUP="event"

ACTION=="add", \
        KERNEL=="event*", \
        SUBSYSTEM=="input", \
        SYSFS{manufacturer}=="Logitech", \
        SYSFS{product}=="USB-PS/2 Optical Mouse", \
        NAME="input/%k", \
        SYMLINK="input/logitech-mouse", \
        MODE="0640", \
        GROUP="event"

Author: Cornelia Huck <cornelia.huck@de.ibm.com>  2007-07-18 09:43:47
Committer: Greg Kroah-Hartman <gregkh@suse.de>  2007-07-18 23:49:50
Parent: be3884943674f8ee7656b1d8b71c087ec900c836 (HOWTO: Add the knwon_regression URI to the documentation)

    Driver core: check return code of sysfs_create_link()
    
    Check for return value of sysfs_create_link() in device_add() and
    device_rename().  Add helper functions device_add_class_symlinks() and
    device_remove_class_symlinks() to make the code easier to read.
    
    [akpm@linux-foundation.org: fix unused var warnings]
    
    Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
    Acked-by: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

git-bisect start
# good: [2f493789ddc636ff19156b2752763d76ba563b39] Merge branch 'master' of git://git.kernel.org/pub/scm/linux$
git-bisect good 2f493789ddc636ff19156b2752763d76ba563b39
# bad: [a80ef3844fd9f87461578d98a992db6cc64369f8] IPv6: Don't update ADVMSS on routes where the MTU is not als$
git-bisect bad a80ef3844fd9f87461578d98a992db6cc64369f8
# bad: [febe3375ea690a6cf544c33fa0fea1a06ff451ee] [ALSA] hda-codec - Add HP Pavillion quirk to Realtek code
git-bisect bad febe3375ea690a6cf544c33fa0fea1a06ff451ee
# bad: [83c54070ee1a2d05c89793884bea1a03f2851ed4] mm: fault feedback #2
git-bisect bad 83c54070ee1a2d05c89793884bea1a03f2851ed4
# good: [a267c0a887064720dfab5775a4f09b20b4f8ec37] Merge branch 'master' of ssh://master.kernel.org/pub/scm/li$
git-bisect good a267c0a887064720dfab5775a4f09b20b4f8ec37
# good: [fc15bc817eecd5c13581adab2a182c07edededa0] Merge master.kernel.org:/pub/scm/linux/kernel/git/gregkh/ui$
git-bisect good fc15bc817eecd5c13581adab2a182c07edededa0
# bad: [789c56b7f73218141b8004cb4f775eed8c514212] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/$
git-bisect bad 789c56b7f73218141b8004cb4f775eed8c514212
# bad: [70b315b0dd3879cb3ab8aadffb14f10b2d19b9c3] [CIFS] merge conflict in fs/cifs/export.c
git-bisect bad 70b315b0dd3879cb3ab8aadffb14f10b2d19b9c3
# good: [3870253efb65e1960421ca74f5d336218c28fc5b] [CIFS] more whitespace fixes
git-bisect good 3870253efb65e1960421ca74f5d336218c28fc5b
# good: [4a379e6657ae2dd910f9f06d46bd7c05fbe9ed5c] [CIFS] Fix build break - inet.h not included when experimen$
git-bisect good 4a379e6657ae2dd910f9f06d46bd7c05fbe9ed5c
# good: [7e42ca886b0282679c2721dc4853163cc89b8a34] [CIFS] Typo in previous patch
git-bisect good 7e42ca886b0282679c2721dc4853163cc89b8a34
# good: [c18c842b1fdf527717303a4e173cbece7ab2deb8] [CIFS] Allow disabling CIFS Unix Extensions as mount option
git-bisect good c18c842b1fdf527717303a4e173cbece7ab2deb8
# good: [fc15bc817eecd5c13581adab2a182c07edededa0] Merge master.kernel.org:/pub/scm/linux/kernel/git/gregkh/ui$
git-bisect good fc15bc817eecd5c13581adab2a182c07edededa0

Something went wrong here and hit a single CIFS patch, so I started from second-last bad and the good before it.

# bad: [789c56b7f73218141b8004cb4f775eed8c514212] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/$
git-bisect bad 789c56b7f73218141b8004cb4f775eed8c514212
# bad: [2ee97caf0a6602f749ddbfdb1449e383e1212707] Driver core: check return code of sysfs_create_link()
git-bisect bad 2ee97caf0a6602f749ddbfdb1449e383e1212707
# good: [2c19c49a59ccf2162c0eb999de1ec60c0e07a533] Documentation fix devres.txt: lib/iomap.c -> lib/devres.c
git-bisect good 2c19c49a59ccf2162c0eb999de1ec60c0e07a533
# good: [aebdc3b450a3febf7d7d00cd2235509055ec7082] dev_vdbg(), available with -DVERBOSE_DEBUG
git-bisect good aebdc3b450a3febf7d7d00cd2235509055ec7082

-- 
Simon Arlott

--------------030208080509070402080808
Content-Type: application/x-gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

H4sICJOepUYCA2NvbmZpZwCMPFtz2zaz7/0VnPTMnHamTXSxFbkzfgBBUERFEjAA6pIXjGMz
+XRqW/lkuU3+/VmQuoAkQDUzscTdBbC47BVL/fzTzwF622+f7/ebh/unpx/B1/Kl3N3vy8fg
+f6vMnjYvnzZfP0jeNy+/O8+KB83e2iRbl7evgd/lbuX8in4u9y9brYvfwSj95P3oxGg1VsZ
/Pn2FIyugsHgj+vxH9dXwWgw+PjTzz9hlsd0plfTiR6Pbn8cn2ckJ4JirWhGzlCcMjyXrBCY
6CVSOInYrNumoiILkivZi9ShYCjCSKozmcFGhGtZcM6EhZAK4bkSCEbu4kiGeMIEoFJCOBHW
uDCx80OWFeeHTywnOsrQGXJXUDxPqc3PkW0qUZP2hGAwdhccFo6FSZaEzhKrdyRwojO01gla
EM2xjiN8xkYZtR5IfFwiw+C7D0+bzx+et49vT+Xrh/8pcpQRLUhKkCQf3tdn5N1PsL8/B3j7
WMLR2b/tNvsfwVP5NxyR7bc9nJDX8/6TFSwb7HWuUHoeFDZoTnLNci0z3twkPSciJxYtzanS
JF/ApAyPGVW341HNwaw6wU/Ba7l/+3YeE7pB6QJ2i7L89t3vXzf7d4bdLlKjQrFg8xq8bPem
k9O+L+2ll2u5oBx3AOYTK4tTziRd6eyuIIU526chQxlpLhgmUmqEsbJHPBEpJOdwFpV0YgtJ
hM7dOFREVDlmQef1F2sp50dOgRt72YHHItYyobG6HU6tecYSDggXBCNFIntOcCTQ2slOmM6h
zaLaNxE5STDWjIMGoJ+IjpnQEr64tqG1viQLSRRVfByXhUbDSWNjoEH1gVKr4Rye5DqTXYiu
6U6cneBkBTpBcySlg7GEKZ7agsgFzdXcOt82kqSxxqBELDQIk44Lm8W4UGRlCXAOp5PmLCIW
04Qzu4mksxylsbUcRqkKG1DpQxsgk4xk58dFVpMAf0WuGvpNpii0V0amRejcTJmy0LFGQunM
zKmawPmU03xdM+FoUi2LzMyWDE6alUVFai9CDdBFnoKO74DhNGELeRoX0AeZd8vQobkU+KQa
0tTB4hwIrX00CsuSo7Ax5kkQmK7si3PgVMa9UhTKmY2v1B5lgXz4T2lU9M5StZRJnJBI54xZ
2usIRbILiwiKUpqTLgbHd/ZUwEigIlXQiZPZI/rYn2PhjiSejg3PPa0ObN2+e/jy34P14bvt
Q/n6ut0F+x/fyuD+5TH4UhpjVFpLosDugpUhEiT2PMmc6eTT+TEB2wn6TNbi0ziuYJ0cXBmf
prIHJzoDAYWYO1fHIBdsjWZEePF5kaE7L1YWWUaVFx3SWYvR5thULqUXe/AhjMfgpSHy42Aw
cKI5EmhBhZu5bDyduBFXPsR1D0JJ7MVl2cqNm/g65KD3aJFRegHdj8/cWKPvR70Nr9zY+cRx
4LL5x4Yym089o4pCMreeyUgcU0yY+4hmS5rjBHyaSS961Isdu419NiNgxmarYQ9Wp57dw2tB
V949WFCEx3rkR368dOw90o0zvsLJrOHt63SoMQI1dPCTJjZuhSLLLoglRA7a9ABgsCQzJqhK
MnsPKw89QVJT8L5Guhi7Z9Emm1w5OD6FQCiloQBPDfQmeGdN7pdcL5mYS83mTQTNFylvTTVs
esCVwmMcRZ3GM8Zggpzidp+KpJXTihlvMQJQzcEB1bCUEPQVWRc9jnK2bIJB9psAnLFFE5KB
x5kVmca80DHKaLq+vTrpeE5Urd8tvW9gJCtSs2JCNRQ6uLwk48Yu5W55OhIsWAqeExJrx74c
aGw3sW4UztPWpLljEQFIWRdcBTCuNWcOYIZJB2AmFaM6HmvIhMHxK5UQAT6YYz6LrIp5z84c
A0kIkXN96HTulT1BQsZUTFcF93hjFEOAAnrB20Um/bYU9p9GHacp3uye/7nflUG02/xd+02n
VhBVePyaNNUiLNxIHIXIFR1AeE0j29swDkbtdp8aH0BXM2fXB+zEg15kkqcQFI9nzk06Ik2M
ZY95xIz6ex1VDXtJhq6BOTg4msWxJOp28D0c1P8aGYkYRA3mBdE8ClPSSldIcCVAbXrRJCUY
YgqSMbE2/rqdI6goQENVsiy1iZt0I33S2/rIVobyoikVEZXwTdHZGe2OgU68d4magzRHPXBa
tbO5PXVnMgK2TNfrz1WVKYGDLs8qDjzYKoEm9eQqpKqbjzIjzm6Hp+AFQj5bO+SizlOdKYxf
B0IO0WzDKc6QSg56kzb9iSOBEsJuQGLqiu4JxqzK/pzP/Sc99PiZgBpde1HjZqtGdwNL43+6
HVpncg7RqbW2PFlLanQrLLowZ3hYn2A75wG6V5nD6Tr/x+ZghWf5ufkx5wFzhQ1fRJLBkHUI
s/2n3AXP9y/3X8vn8mV/zJ4FvyDM6W8B4tmv51iGNxQIz3RKZgi7czCAjUhYuAVdslgtkUlq
FhKc0a6qNKMDD49/3788lI8BrpJ+b7t7w1wVaNWM05d9ufty/1D+Gsi3b9+2u/2ZWdOFJZ7w
VKdQXbAqG6XjxhlrY6uvbg/JUBqaWPrxCPtxIVKKOO13jS6UYnmL7xjlHW4jEElfJ4fsHxOt
fg62ttMXgq3xc+ywuw2OU1Rnm/WaIHE7aPPZPhg20paHmnO2JG2u5Voq0nLb4MQd3avmcEZ/
Ipp7Yt+6v9AzWZ51zibovCDelf99K18efgSvD/dPm5evti2vvD9B7jotw7fXs4BxDPLFcYYp
+i0gVMLfDMMf+GaLHKYNmcMUHN6QMje7NTrL6scekogKgl0Z2xqNcstjNiAzYhNS99CEHQdu
cUzMlUZYuByV2q7Wlx4SXCra6lB2Zu9XKonSVNy5stD1BYfxTe3eAOyJ+Nxwib+Pmkq+VqEY
IxGZ/TRb+QHf7x5hn38NXk8KyeK/InUyX+dzzRQ7I5Dv5cPb/v7zUxl82Zg/293z/d7KMYU0
jzNlsryN5F8NRaxwu1IHfEabOY1qyLzc/7Pd/VUf7KN1JupoNs7o7nULB9En9sGonuFs2O5F
kVMr1byKRdZ8qgK3RnBggLIIQRuk1GNyKpqMzkz86TgGwD/Y27Xd6wHU04jm9lwo1+B0gDtU
X+ydjxIET9ECgTMTaQHr3VQ1Z6KYhiaUTlptec49/FJOeZthymfCHZYY9qrhPYE8j5xXHDlo
SDandorbTFujpAUgkrcglB8cKBtY7YMq8tYdmgl/XcB624wXqgTKZfP+s03R30FISLttRNGs
zQXmLbCBwNfZaRcdqNB2gk9QXLjhSyLVkjFXRwl8c4GlB74Ga+qAL8D3kg64uXhqBi8nVMqd
/eTMAQbDnTjANE1pzqh0ZdBDZzLrlHY/rFSnmVmP3px+NdNeiuNq9xIJmGgPf8cp3r57ePu8
eXhnTz2LrmXjFpMvJs0nc/+2AF+4Ba2Vgcm6xC4MnMeYtRD1taQEJaMj+3rJHN1JRyYnXaGc
nKXS0gwLk53iE4+Km/iFduKBXhTbyQW5nXQF98xvC1+t1uHC1hfzVXOUVLXW8zR0azGMHucp
sGaExX28gAmTsDRxYobE3EcT01R5nEvQyBH2HG/ASazcOGDNJUsQvze8W5VpnFJPVALIFHly
hwYZitFk6krmhoJGM0t/LKAbPR2Mhne3z7ZYYZi7o3maNsQcHkee+a88vKHUk7kbXbtvMBF3
XwwT+CRu72cJc+qa6sq7udtKE2N+2O6CL/ebXQCe/lvZ8vGNHakuBH2uU7AvX/eORnyuZsR9
BZKgTKCIMvdqicjtlobu+aFYi5XgXdduudmVT+VrI/uI45nZX/f9yJKa4htZFSS4HWaE/a0p
IcSPFfGcpqlPsPQN77AflX9vHuwU6rkMZ/NwAAes7ZRKhfIIpcy+aAalXBUexFRkVTIiLGhq
Kdx4qc0dftMPrcIPHYGy90j8gYAshEepQOgKNp0TsaAQjTvkBz5yCK3sSL1KQJzKzs4LryJn
FlQ0lfEB0LowPkLB0abOdOG5GSyRbaYsBIRu0Jy5+p15rkqPeLSaTj/eTHoGHo6mV9aoecOi
wWM3Fjxey++3D9snOybJeTMddKht6AB0HLXmQj1XAKYB5nfaJ5UHNKYgOD00ZswI4ZvJoJek
aJWrdAgwW5r8Xua0jEeitC7L6DYWa65Y2iqA6JDlYdSLl6tp/yTCXrRA7iniSLDM6E0cLSKf
xdAMBFITlbiSwRDhmhEoblYC0TDTSLoH5QnKFXPjCOGGo5sxXrkvq+WMasrwlce0x1lVjOXJ
jOZrY8+UZy9UQvO5uQatMqQOJyiyS2mqO4iVTpY0ttL0p6qgiraWmafy/rWEjkCzbh/eTCq4
yrV+2DyW7/ff9ybnEPynfPr2YfPyZRtsXwIjF49G2zYMidW1lrAtvRueRLolXd1eIirnjQkZ
QO28VZ5hV4KBBruLoCKiECf9FYMQDaSM8/UlKoklvUTT3qLzwTMeMYJ5wCFRqXsXrZR0XXEF
K/Xwn803oDqmlj58fvv6ZfO9uQOmqaOyoCvzWTS5GvQvfq1yHXBMG3ti8nIyMSaUirsOBv6H
hdRMtEzpsUMWxyHz5cWORP9mSiY+mIyG/Urm03AwuDBtkyts5V1b2KrGL/LtraFgebo2R7WX
GUTwZLRa9dOkdHi9GvfTZNHHq0v9KEpX/PKR6O9FCRqnpJ8Gr6cjPLnpZxnL6+vR4CLJ+F+Q
XPcrGa7GFyZlSCaTXpI/q3qAvN/84eFo0M8vhz3o1xpqOhqOL5P095LL6cerYf+68AiPBnD4
NEujHnE4keVk6RIIuVjOZf+yUJqhGblAAxt5Yd4yxTcDcmGflMhGN33ivaAITudqtXJNRuHp
BA8GQ6/SRiK7qDoaHkatDOgivGAIO05sZV8e61jHcZMgEAUXQCnhulQxba37enjSLb4qmJop
zz0HICH6SsHT8PTeNk4Vtwc262LYXx43r3/9Fuzvv5W/BTj6HRwm61brtKcNQ40TUUPdfB3R
THoITr2K3vZy1o9uVqHW89s+l/aWvAa/lO+/voeJBf/39lf5efv9dN8TPL897TffnsogLfKG
Za4WrvZcAOVfevhuwlXPaxgVScpmM5rP/AQSoxx823WOfTu4RFRVZLfP1h6q3f3Lq5lGl3Np
LoXbJ65JEuNLFLT6e4FIIvlvSFIaymZe+DyPp+0/v9evAz12a61qJnxZ5+MpGi81qIlVJWp+
RoDqZuUxvfVcvVd+NRrh/gEQxR/7B6gJ2nq8S3RzoZebqz6CiCtNR6ynB3N1Itc9m4YE9hXN
ZWSGKp0GZsaXHjvR9FSdnGgk6mEEDD71xFcVHtxVkDCPt3nQp6vx8GbYs+LEF/3UklKoAtzl
iGWI9qiCWaSSHmHifZKWU0VZLx75Kp1qFc97+KeeqvNaOBXpOUhynV2P8RRO7MhPdFetv8kA
DfqIwBPH/XjqDdRqRcr7Oojw+Ob6ez9+0GdEJR/3TLKnPqpaKOFL7LvqbjJnzJv1+XZR4zIh
yrx1OYCqUkQtcpkjbl5rcedBzVW8EEz4sJ+IYN6W1eUM8hz+itPWu391ge2beTk4yLjqcZ3i
QlKPJ1+jjKXrQ3tOzLGxwySZHHgwHN9cBb/Em11pMvDO+pCYCmKy7a6MAHRhejh5XG+fX3+8
7stnK9fdyLkbYr0gImSSuPOkePuy322fntrW8dgYQuB0na96mNEswdTmypF6PfMCzjA7EHcH
k6Hn1Y4TBVFJ9WlSbyRXYv2vyPu4jxYHdtoIgZbNnLbP8GUI09zUwh1uBKS7jMORezxD68Ne
vbHrPu1FlnnSUSyPfF4gcLbwvQ1G7gqU0k/OIhVV5PYlX3XNFQ59r16BRffdr/FkDQ6ap6yF
mKrDRmVNRhv5lgRxvs6Ir9a5yGeefDhGUoJp894oLUgeMaHH2JPbratUfHeqCR86k0fVxV67
Ug+Avldqsmg6HA7b6eozPkJcEVxVAcfUkykOr9z55To35es6mnnc6iqp7XMIiA8RwxblbmOf
IyVJ5tuJ0bxd6nZCTkEGsasgyiAUawjmAaS5x9U54uFYE62WVPou6o+E0+HoxktgfGwtVqbO
3XPqJZU3vjXkFHsdriKPTN2RO+Xvk+MFRVok1HPFL/HNaDAeek85Nz9WobwK61i3btXJktzj
EkfpyJUpIO0uKgAcDI99rdERlaYi41g3WL1u4J6EnI6nnhxigkABJu5h1iRN2TL2+N1iOpzc
+PZ2eOPZv7knwSXn65F37xammJ+qteeaaMZyT0YsX7k7BYd37IsVkUq9Z+G43e7JKeGtIQjg
aNq+w9JUinDRc+G/PNaSDDudFjI8FU+gx/tv+5ZjAnhQ7wp7fp0i1HO09Kk9g+amjKyQXrxQ
6XToecHD4OG/kRvf67pnEl+9ibug5+g6tAt7/HbfYH3Zi0PVD6JeLMn9OGNspBLEcxNrSD7B
Hy8SFISxWV48jdTHj6PrkZcAZSEYcBQxfx8JE/STx4GvxkD+6ZlXogcDcym6Dv2FUYkbFUcR
9bwrxz0ajbcciSOYc9vJgsfaCWxnXBsU3SozC1ml+qBPC2QgWql1E2ruN5EiTWAoo6pgsAHM
OCctLhlxD89MXVqLNB15Stuke01kmuC25+mLzcE7dK4EtDHJU2YXvwLs8JsldtcGZOoWfXXX
Fd68NyLgS/Paksoo93i8rTd169jv5dvbvhuOnuocedEqfASAjmPzRp4punIHORWR4RE0d1eP
vpa7J/OO1Ob4dtRra0CdscJEhYvuyEeM5hIVztivSSaxICTXq9vhYHTVT7O+/TiZtsf7k61b
c2gRKNnCN7Bk4ZwFWbgC3norOgVkjZZzsq4uo63f6TlAQDXMm7+ucsKA+zb31MacaNL5RZKV
ukiSk6Xy6L4zN4ot0RKt+zfP/t2a6n14OWr+Ws0BqFHqe0X6RGKSdfDJ+QU6UEkQ2ICNuNQf
jc372fMLZOYnbeacQQR+iZAVOJnTPrJuFVyLAALSlFQd9RAtJLhfCPUcZzjvprR73nfijfur
+ggMF7VQ+feY2r9WcFAYWPK5sJVsDTdhkWC5DlXep2/Ag0TyMhGF8ChjnndQ2kSjHio40JKb
Kt1L3VUvCGaol2YNgarPutYU/9/YlfW4jSPhv2Lsy2aBHcSSLVnexT5Qh23FuiJStjsvgqfb
kxjT6Q76AGb+/bJI2SYlFtUPkx7zK5HF4k3W0Yg/g0ljc3x5EEb76edycnkZu9oPS91H9Web
BtO5NpRkMv8XlBrNC5qgiFjgRgtnaiGpSI1NER1BBAPRaOoMcJaGvXEu02uyN2a6JnnS51pu
yX8cX473fHm5PIjehLJTbnV2rB0syJu9knY7DzEFANM09GZLjlTwICGVemvD4/np5XxUn/70
TwPXm/Zl0CVfODBZz6eHNiF1dsd/t5oZvfq9phqlAUVlBoq6bUjNFP08Fa2bAoxaOxLXRJIc
WFLEum88Fc9JcdcKA0ukX1wIVRUuY05xwsCFQc/K0kha68aVUjP++ek3AHmKaB/xXD7YEnW5
dO7q+pl/oSYNDDAnXAZtxe4Uiyj5TIgmSodz/3M9X3WpAm5jamQPjm1U4KkCM//I03bDe2mG
ZHrxNGo+V+z5wCzi0lTjYlcTpQv2fMfUs6U/Rwya+ZkEu/wE5VOjVilZa3rD/CfopZkLAIxZ
sDy2YRjbHBUefVC02KUxdvTjME0pjgmvROZqw0VNv+omP1aXm7Baf1MDm6p4Zb6RAbB23MCc
DW/6OCmLfm75mqCZYXUEbJdaviM7TEEr35Md4n0oChYz/692jV29FjTCQam4h+N8QTIYWShe
k7THAvCixEcAYv4tYN38mA/JtfD9NPQYwCL+X2UeH7z/CR+/RivCXc8Czo20H63YnPfs/Xhy
xCddeYaRZxQ3mpDH788v57cfP9XTCScFL17SrYryMCWTq8jsw/GGD6djKOq6uwHXBIYXSfl9
6mBallfcn9nxgwXP44Xn22B4LEFxvt+ygch+CkDQxjQ+ELrCKXJfzoV4WXHR7EpYsiheGsE3
gArO92jrjYWqLi3DFSgkPMfxNOeruMXDQUui0PI1H7lLz4b7s6kNXvoHFGakpPzwnuPfswbn
TXh2hVtkjKA3CeoIl2y/xXdlGZflbDBy8vPr/enx8fh0eubDBsZR9OP8yzR+aMK3kzVtY+rM
Zgtk13QjWZibjUN+4Fq/ljYpVhI+RwQeUsKNhiy92XI8n6VjpcnJwQ8WnpWG0cz1PLyvSEs6
1FLmRgIT3AhJ2NCxcjbp0NgQNEFMrYpc94KKZE7QN8a9WWbi+CqcoGSmO5vNPled/4ifoEyh
b46lSAlfHpp1UzdWwZN4MXeCEZLcmbrOB2i8D9D4H6BZjtPMRvlZuvOplWYbsATxU3vNRug7
2EnYoXLGBrM/Ir7Vwgmm3spOAybG9RhJhXgDupCsM88JaD5G405HaGAo9sXXI0lZsDB1zCxH
Ngg3gpHZghMsxgiCEYJgOkYwxmQwxmQwxuRyjIelOzazOr6zHJ19fW86MovD/n2cZu7aa2Tb
EFxpchrNF7nzIaKR+kuycLa0s8UXdD/wiZ2GOdgz9Y0kcEemnX0wWwSYJrBCs/wIjfsBmtkY
SbYIPEbHqHx3sVl9gCgZodrEpLIXJq7OaR4hlxywnlnW4BzsKf54f7oXvv+6hzSDVn++innn
8KaOOYefp4fz0XBbCVqJuim4TNrNM8eU1nlRNEBuPy0ildTyHj7wSwIS71CdW0mxSbKKbw5A
MFSEChlmskt3KaJiAnDIgnlgw/dfI+S5v6vFCL5fLhGjrO77Crl6uMGuBaeEeO7cJ6Mk5ikR
FL/qdjad+RaYJcRb+I6tCAaeOaiF4ltZGzU8riwunNm830O6ZL6DpQTD4l04bPT8EFp4iavI
gm6SQ9rkbVljatAa2TrJMX3KrgEPga1/pTu2s31NVkkbRUbPUXxMCa0adPxUu5rjtt6T5G6A
KERJAv79LkUVwqH0XYr1f0DTMLfB27Lgn+9xnSXh75bn0OYJ5fMlFqABSBPmOwfXs3XTcsez
6s+iWiYwWgPksgjwcuchSyKgNJlPLWixjPhOHsfZzg9w/apv0XRmyb2ySPFbPfN71kvXi8QY
vJILhVq9C0mEd2+W4Lqokojvp1LcM8+FBjSnSpTFmIamu0w+unuReS4pYAJHok0PGCwpnTWA
OKOeHiZi1pj7k9+Pr/wXVMukSgdZkd3CQS7HAA6beI28Qt/gFhGbQkGGCio3buGyBuMPu8gB
jDEQ6QiLkihG7rqENMEp7PqOuRYWV4+nv6LnX2k6+RS6kfsvlF9AWzCOj8rKkh9fj/k5Rcmk
h1eP72/PLlpKlfFNgI1fTjRZvTw/vZ2eHq7ZR++vb88/z6+nAaxkDRNxQ1mZp/TqF4Sn/0Yn
n16Pb6fHx/Pb6V+TP5SPNc746Oan+CUu7IM7t3U4gbszvDljEkwDHM/ZzHFRdJdQ57DEv6be
xpm7U1vpznSqB3K5SohNPvG2ejm9vsG7pk1GVRAs8EIEfLBJyF1MpyM4LoPMn/OTykgV53j5
xYH5ZucZnfw9TbUAEr9lznTm4WKP03DGs8zDUYrIRgGxgfIxgsrYdtHk0z241rW0GvSdYLRv
uGOStfRtOXYWQzfoEG/oU8FH9o8J+Qkezo5Pn7fPL6fj04TdetznSDgHjtnOUgveeu50irdu
WXvocfiCOzO8d4VRPvMs4ztbx2w20xkQPLL3Jz7Rfa6ybKgMIKe8rN+tYC5w/YN1rnAtI0lu
+78yZ2phWBLlXGr+dOQJ4Has1KtchJWlW6SUj0hbt2mIb7Y3krs9wWD/2BA2K0NSd4rQd+a1
/kh5SdWETcJB1dcvx18/zvfG98JQ+H1fb1ibRfHFsfdw3J1ffz0e/7YYafKzVpWRO1MOty3v
mkBsCkRZOzTZO74+82HycCld+goc9Dmer1FDaU1A8wdCF4BGa5llUFn8xCfCfSi7N1DnV/Lt
/Eq8Pz0oqi9lU8QX7Br8QAbAFaQT8nL/gy/D9xBkTvmuUOMrFnE/zBAkVVGuJ9Rkn6dxqifS
5GuTFJH+JN4BQ4sEBS/56SVvMj23PD3wEcShAStoImxw1mlBEbaG39UsMtQW2L0gFw+/OkV8
V5A8jSBkU1n3i5O9Tph7kaonos6mtgv40JfTDYVwnOZrMSjdaJF78WI5uKUSwqwafvgSimA6
QyRaLloIVRT1mcFNSASraQ0dAMVzVpGdBaWIro6Uv9DWahy/98I3qFCfZxB8TgpXf5nvPO2n
pplWyCB2gmCJskMyOsPedCQ8n1rx1JsjB2+B4761brBwV5fjRE2A6SpcYNcOzyzwN770ugGK
w6HkgKIR4cukj8N5ih2fBUznbuDYYP9gKVsoCkF84RIfTKTOiEU4fD6xwXydsX4us5/bs5+P
ZI/jeVkQHExxLIk25WyNwqBCuy5H4HSMIP6Cl583znTrjOF42yYFqDxMR3BLAdRZzgIr7OPw
KscUhwDdxMSicCgpaGUF8bGeRomzQA6rV9zSZQRjwWE6SoCzsC3rNd/u4zx091kzS9c8EEyf
ncNF7nr4nFFFh02NonVaMczvrsDzZOba0KVvRz38awo3trs0xLw3w+4KnAIXDFnWhIc53b+c
kjyyCuz4ER7n7S5f2WZasRHotEl6aptXA1tk/YSbMvskK81bD+6dlSIiKRnGPaLSU8nzk9ST
Or4/nJ+NejVC/kOX5eWv01O3AZZZaR/Bphn2W3liDCnFZSKjx12tNa8bPC1Rj42IbdFAhqod
mbJJg/r38umSFDMV1KwJilzh9/IcNtvBiYv1fnVEc17itm6iGEHAfQsCJX2oXy2zePRjMQhr
EB9IfgyuT/Td8y29jTJCcTttfeeOikQElusXUEFodcR9oHj+YOYm3zy/vikOc4bWg+KBhsts
KG2RKoMmprQ0YHVZsnbTwIW1AWUMjP5k7PFeZfgZ2XH8AxSJV6jjCRFTc2NZf6rJAsexZlwH
xPc9Prh6RFeRdXaW0ePx9dX0Xi+6W5QjjHWWGNeAUyVL/jORj0hlDeqvpye483oV7v7+LUIC
/lM6aDy//nmZW/55uf/+yY/7x8fX58nvp8nT6fRweviv8HWtZrg5Pf4Sbq5/Pr+cJuDmGqJs
8b6rN3JHPhCYTLb49NKoCCMrEo7SreokwYw1VLqUxpjrWa3YKhrPi/8/YaNUNI7r6fJDZJ43
SvalyXFPYiohyfgqRUbJtqTOcaoM/FH3QqTeJvefx+8Q18ywUMK3eRwFFkkLN8Es2eIE+kvz
tVhhC4WMkobShTs1ftZZuvGZiX/4pt1m9R5u++at1yx6N5lmFpI89fGHXY4iOp5ikMcNaw44
3PA5eU8yy1STlp5F5lmyLhmsrTiFZR4Lk7q+E1YYiE69LALPILqraoiOEt0tIkTJUZKJSJv4
8/YmRV8zxWQfCxNjFF+xOG0TzFWQEDSoYXUXq/gISimoRKwtowcXBQSCivgSDhHgS7w50nJP
at6oOAVLKDMvKjTj8/MD30wOrm1FFXU/FKJCVZLEA7tttWEOJKqb/mdNQtZZgvk6AYqDmChz
I5vr48P305sSk1b7ck3Qls7z4e4XOp9hNuK7AuiX1Eyvh8eBJPZy/v697+uP/1ukISnMbZrE
ZMhOfeITDjv/hKX9+f5PzSs1i4Z7N3njz6fj5IlPrObb/pzww/46NbjPgA+jx/Pp6e1aGUiK
h/IgzcHQuZU40sLpnQgedtlVrCCapnSjqGzlkgNze7GAu6T2AG6JzaK6UBidm3B0JrPUE2SG
w+SqpOmB746yHhMCpEnU1JjbKE40F3FsTBvjL7r/Cv4TVT/k5eRhRPi2U9OZSVK+kqxoi0Q6
/jKAbtmpdboG7KQ9QUPK16ZEXOcekNorsFFyACBXFesVdbHawP0+CoJW3AED6zLHJMEPLSxd
qXECZcIg4ulADJfBcs1A6fqsxMqT2FzrfSvwVXHz3i7ds3+G6DowIgYDgh9blr4/1bL4Umap
6r/xGydS8SZetf3fRXYtMi7p5xVhnwtmLpJj2uc55V9oKbs+Cfy+xpos46SCXXrgTU14WsKC
T3kF/nF+fQ4Cb/mbcw34WLBBtxRJ+NZewPV++GDxenp/eBZBewc1vHnQVxO2ui6YDDx+RyOm
vqzdUfU7llc6syLhNhDMtw0NX4GyEOm+HdpWPTvDq8JbrjIg/1xkZrgG0OuveLnEJxKywrFE
+CLG0A3+IYeqrEHhMME/DS3s4FAkJGV+vD5Y+Kxw7GtxmOMo7xo7DGsGn2nhCsVaSPu9tJDN
+lP9vZtpQ0OkoB1NwHMUklHEU1NcVg7HWsHxsOTYULSGKhrXIkELsQum3EoR4qf2SXKAa7V+
/WWYNWU8NkVdKc7X5O92Tam6qexSwbPJzGR0zEG+tMFX7bYOPW3VvUG02uYz08VzHmqTCfzm
063h6bsDpFOd//3j/e2P4DrzRak2rlNYbhnRYw7eUs3nQYHvE7Jtq72IdW2KcJgOtz4iTUxa
g9LExGspjTdTAte/BUM8OBVRhQ7RMib4JGQcMdXx5e0sjFHY37/0PWhFagZu94trIGmTp3ax
ll1Jr1dcxze+Z59kx6fv78fvJ+XwcKlFpjSO2rhdI96qm9HrCtjOEbNjjWjxISLdQs9EEuiO
dXqYO15GgFwW9Yg+wG2A2Lb1iJyPEH2EceTo3yOaf4ToIyJATG56RMtxouXsAzktvelHcvqA
nJbzD/AULHA58X0m7NfaYDwbx/0I2w5mUgFUhEZpivT6CydOv8tfAHe0ErNRinFBeKMU/ijF
YpRiOUrhjFfGGa+Ng1dnW6ZBW9vhBmmrhq2C69njDFqzv7+Dtnz2fP/nJD8+8Qn3RbuRyHLj
2Y2yuhELTTdzK56jyhX4bzUfELYc7r0oi9K2p5en0+Pkx/H+Txkq+upymUTCE9cqI2s6fN+T
2mVCzU/ZrRTCb3beUH4AAuc2yvGJQDQVvjvUfXs1BXjohIgsYZlRSzhjbKOaQHhkKkszOsWB
j7fg6l85v8hUutFiRXauxUC7EvZhjeosDd6+5Fd6DDOeLDYiiFMuUP3D8Y6LDHmFkXBVJwlE
E8GqVjMubpYcEtqvXpW2WUo1Xz0XYnG7aXRs1PFUpQXIoJ8lUhKQtiTjf7Rz4y4RCO+RvQ1v
Ug3jWXeAKR6E1hMHjdixyuWYYPlyDkCJEhRiV1Bzoxc6RqKtKGqYx7YMv/CugYqL/9cpXQ6/
BXdLluZFHM10vPfeiS/XCPxMl7TC66iqdCqjLvAC+RwgZX5r96hpGR++YLfVv9i+6SvLe4ni
izgOmQxJhe/BbuQP2gHkBxGQV1m5H4pBwG1DMbdBXZflsOhHeHcv4eFSzX++FXmb2vQQ+O0q
BY2OvOruCJSbPw7mVQV3MEpdyoZPYJcDS+fJ8f795fz291CNALyD9pzx0uuohZuUBAtFhl8g
yjjYyplE/Ab/MpoWcJccZtsorTZqL+gQOPYMEnNScAEbiHOiKe52yYcojJBLBYEXTZbZ8Dye
ozXkoDfgg26IY0p0Pd+U7Dmuget95SE6ZR0BW9eYh4eOYr1y3CBvMpz7JAoHHHFpGdipRoSY
1XsbLP7EOCOxHtOnS12Jv7Z8QxF/gm6sgtqXfRIjweA6ogd7gW/gEbzRJoWVSZJQvHAOIjlH
hDLPKlRO4FtrnhBLwXU0V69VuuTthnwjsbU6RROm1NaW0jH+sEZ5Gm1IksFfe2eJZq6dgq8c
WYZo9F4rb1x1LnPF3sCf8NZO4r5jQhPZOinj4Rtbdv795fjy9+Tl+f3t/KSqtIUpqxMwNE7U
/hWBwT5jejNEDtaoUZsyvgIaa8VFptcoMh9FsjQcyvfy9MBBWOm75lNTb416C8hAVbU/wk8e
pebMVyb1tAN5moyge3k1ktHIW/DdyPdGdIjw1FZs+vU1L0xLuHsLy1LJfis8/NKIZASWh/8D
2M2HrSerAAA=
--------------030208080509070402080808--
